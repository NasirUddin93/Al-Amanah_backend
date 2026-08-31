<?php

namespace App\Services;

use App\Models\Receipt;
use App\Models\Transaction;
use App\Models\User;
use App\Services\Concerns\ResolvesSharedMembers;
use Illuminate\Support\Facades\DB;

class TransactionService
{
    use ResolvesSharedMembers;

    public function __construct(
        protected ActivityLogService $logs,
        protected NotificationService $notifications,
    ) {}

    public function list(User $user)
    {
        $query = Transaction::with([
            'member.memberProfile',
            'creator.role',
            'creator.memberProfile',
            'updater.role',
            'updater.memberProfile',
            'receipt.creator.role',
            'receipt.creator.memberProfile',
        ]);

        if ($user->isMember()) {
            $query->whereIn('member_id', $this->visibleMemberIds($user));
        }

        return $query
            ->when(request('status'), fn ($q, $s) => $q->where('status', $s))
            ->when(request('payment_category'), fn ($q, $c) => $q->where('payment_category', $c))
            ->when(request('member_id'), fn ($q, $m) => $q->where('member_id', $m))
            ->when(request('type'), fn ($q, $t) => $q->where('type', $t))
            ->latest('transaction_date')
            ->paginate((int) request('per_page', 500));
    }

    public function find(User $user, Transaction $transaction): Transaction
    {
        if ($user->isMember()) {
            abort_unless(in_array($transaction->member_id, $this->visibleMemberIds($user), true), 404);
        }

        return $transaction->load([
            'member.memberProfile',
            'creator.role',
            'creator.memberProfile',
            'updater.role',
            'updater.memberProfile',
            'receipt.creator.role',
            'receipt.creator.memberProfile',
        ]);
    }

    public function create(array $data): Transaction
    {
        return DB::transaction(function () use ($data) {
            if (!empty($data['transaction_no'])) {
                $customTrxNo = trim($data['transaction_no']);
                $exists = Transaction::where('transaction_no', $customTrxNo)->exists();
                if ($exists) {
                    throw \Illuminate\Validation\ValidationException::withMessages([
                        'transaction_no' => ["The Transaction ID '{$customTrxNo}' has already been taken. Please choose a unique Transaction ID."],
                    ]);
                }
                $data['transaction_no'] = $customTrxNo;
            } else {
                $data['transaction_no'] = Transaction::generateTransactionNo();
            }

            $data['created_by'] = auth()->id() ?? 1;
            if (!isset($data['status'])) {
                $data['status'] = 'paid';
            }

            $trx = Transaction::create($data);

            $this->logs->log('create', $trx, null, $trx->toArray());
            $this->notifications->send($trx->member_id, 'New Transaction',
                "Transaction {$trx->transaction_no} of {$trx->amount} has been recorded.", 'transaction');
            $this->notifications->sendToAdmins('New Transaction', "Transaction {$trx->transaction_no} recorded.", 'transaction');

            return $trx->load('member', 'receipt');
        });
    }

    public function generatePayments(array $data): array
    {
        return DB::transaction(function () use ($data) {
            $paymentType = $data['payment_category'] ?? 'monthly_payment';
            $rawMemberIds = (array) ($data['member_ids'] ?? []);

            if (in_array('all', $rawMemberIds) || in_array(-1, $rawMemberIds) || empty($rawMemberIds)) {
                $memberIds = User::whereHas('role', fn ($q) => $q->where('name', 'member'))->pluck('id')->toArray();
            } else {
                $memberIds = $rawMemberIds;
            }

            $amount = (float) $data['amount'];
            $months = (array) ($data['months'] ?? []);
            $title = $data['title'] ?? ($paymentType === 'monthly_payment' ? 'Monthly Payment' : 'One-Time Payment');
            $dueDate = $data['due_date'] ?? now()->toDateString();
            $description = $data['description'] ?? null;

            $customTransactionNo = !empty($data['transaction_no']) ? trim($data['transaction_no']) : null;
            if ($customTransactionNo) {
                $exists = Transaction::where('transaction_no', $customTransactionNo)->exists();
                if ($exists) {
                    throw \Illuminate\Validation\ValidationException::withMessages([
                        'transaction_no' => ["The Transaction ID '{$customTransactionNo}' has already been taken. Please choose a unique Transaction ID."],
                    ]);
                }
            }

            $createdCount = 0;
            $skippedExistingMonths = [];
            $createdTransactions = [];

            if ($paymentType === 'monthly_payment' && !empty($months)) {
                foreach ($months as $monthIndex => $monthName) {
                    $monthBase = $customTransactionNo
                        ? (count($months) > 1 && $monthIndex > 0 ? "{$customTransactionNo}-M" . ($monthIndex + 1) : $customTransactionNo)
                        : null;

                    $memberCounter = 1;
                    foreach ($memberIds as $memberId) {
                        // Check if the member already has an active (pending or paid) record for this month/year
                        $alreadyExists = Transaction::where('member_id', $memberId)
                            ->where('payment_category', 'monthly_payment')
                            ->where('month', $monthName)
                            ->whereIn('status', ['pending', 'paid'])
                            ->exists();

                        if ($alreadyExists) {
                            $skippedExistingMonths[$monthName] = true;
                            continue;
                        }

                        if ($monthBase) {
                            $uniqueTrxNo = count($memberIds) > 1 ? "{$monthBase}-{$memberCounter}" : $monthBase;
                            while (Transaction::where('transaction_no', $uniqueTrxNo)->exists()) {
                                $uniqueTrxNo = Transaction::generateTransactionNo();
                            }
                        } else {
                            $uniqueTrxNo = Transaction::generateTransactionNo();
                        }

                        $trx = Transaction::create([
                            'member_id'        => $memberId,
                            'created_by'       => auth()->id() ?? 1,
                            'transaction_no'   => $uniqueTrxNo,
                            'type'             => 'payment',
                            'payment_category' => 'monthly_payment',
                            'amount'           => $amount,
                            'status'           => 'pending',
                            'month'            => $monthName,
                            'transaction_date' => $dueDate,
                            'description'      => $description ?: "Monthly subscription for {$monthName}",
                        ]);

                        $this->notifications->send(
                            $memberId,
                            "Monthly Payment Due: {$monthName}",
                            "A monthly subscription payment of \${$amount} for {$monthName} has been assigned to your account and is pending payment.",
                            'payment_due'
                        );
                        $createdTransactions[] = $trx;
                        $memberCounter++;
                    }
                }
            } else {
                $memberCounter = 1;
                foreach ($memberIds as $memberId) {
                    if ($customTransactionNo) {
                        $uniqueTrxNo = count($memberIds) > 1 ? "{$customTransactionNo}-{$memberCounter}" : $customTransactionNo;
                        while (Transaction::where('transaction_no', $uniqueTrxNo)->exists()) {
                            $uniqueTrxNo = Transaction::generateTransactionNo();
                        }
                    } else {
                        $uniqueTrxNo = Transaction::generateTransactionNo();
                    }

                    $trx = Transaction::create([
                        'member_id'        => $memberId,
                        'created_by'       => auth()->id() ?? 1,
                        'transaction_no'   => $uniqueTrxNo,
                        'type'             => 'payment',
                        'payment_category' => 'one_time',
                        'amount'           => $amount,
                        'status'           => 'pending',
                        'month'            => $data['month'] ?? null,
                        'transaction_date' => $dueDate,
                        'description'      => $description ?: $title,
                    ]);

                    $this->notifications->send(
                        $memberId,
                        "Payment Assigned: {$title}",
                        "A payment of \${$amount} ({$title}) has been assigned to your account and is pending payment.",
                        'payment_due'
                    );
                    $createdTransactions[] = $trx;
                    $memberCounter++;
                }
            }

            if (count($createdTransactions) === 0 && !empty($skippedExistingMonths)) {
                $skippedListStr = implode(', ', array_keys($skippedExistingMonths));
                throw \Illuminate\Validation\ValidationException::withMessages([
                    'months' => ["Payment dues for the selected month(s) ({$skippedListStr}) have already been created and cannot be duplicated."],
                ]);
            }

            $this->logs->log('generate_payments', auth()->user() ?? User::find(1), null, [
                'type'   => $paymentType,
                'count'  => count($createdTransactions),
                'amount' => $amount,
            ]);

            return [
                'message'      => 'Payment demands generated successfully.',
                'count'        => count($createdTransactions),
                'transactions' => $createdTransactions,
            ];
        });
    }

    public function update(Transaction $trx, array $data): Transaction
    {
        return DB::transaction(function () use ($trx, $data) {
            $old = $trx->toArray();
            $data['updated_by'] = auth()->id();

            $trx->update($data);

            $this->logs->log('update', $trx, $old, $trx->fresh()->toArray());
            $this->notifications->sendToAdmins('Transaction Updated', "Transaction {$trx->transaction_no} was updated.", 'transaction');

            return $trx->fresh(['member', 'receipt']);
        });
    }

    public function collectPayment(Transaction $trx, array $data, ?User $user = null): array
    {
        $user = $user ?? auth()->user() ?? User::find(1);

        return DB::transaction(function () use ($user, $trx, $data) {
            $paidAmount = (float) ($data['paid_amount'] ?? $data['amount'] ?? $trx->amount);
            $paymentMethod = $data['payment_method'] ?? 'cash';
            $paymentDate = $data['payment_date'] ?? now()->toDateString();
            $notes = !empty($data['notes']) ? trim($data['notes']) : null;
            $trxRef = !empty($data['trx_reference']) 
                ? trim($data['trx_reference']) 
                : (!empty($data['transaction_reference']) 
                    ? trim($data['transaction_reference']) 
                    : (!empty($data['reference']) ? trim($data['reference']) : null));

            $originalAmount = (float) $trx->amount;
            $remainingDue = max(0, $originalAmount - $paidAmount);

            if ($trxRef) {
                // Check if this reference has already been used on another non-rejected transaction
                $existingTrx = Transaction::where('id', '!=', $trx->id)
                    ->where('member_trx_reference', $trxRef)
                    ->where('status', '!=', 'rejected')
                    ->first();

                if ($existingTrx) {
                    $ownerName = $existingTrx->member ? $existingTrx->member->name : 'another member';
                    $itemLabel = $existingTrx->month ?: $existingTrx->transaction_no;
                    throw \Illuminate\Validation\ValidationException::withMessages([
                        'trx_reference' => ["The Transaction Reference / TrxID '{$trxRef}' has already been submitted for {$ownerName} ({$itemLabel}). Reference IDs must be unique across all active payments."],
                    ]);
                }
            }

            if ($paidAmount >= $originalAmount) {
                // Full payment
                $oldTrxData = $trx->toArray();
                $updatePayload = [
                    'status'           => 'paid',
                    'updated_by'       => auth()->id(),
                    'transaction_date' => $paymentDate,
                ];
                if ($notes) {
                    $updatePayload['description'] = ($trx->description ? "{$trx->description} - " : "") . "{$notes}";
                }
                if ($trxRef) {
                    $updatePayload['member_trx_reference'] = $trxRef;
                }
                $trx->update($updatePayload);

                $receipt = null;
                if (!empty($data['create_receipt'])) {
                    $receipt = Receipt::create([
                        'transaction_id' => $trx->id,
                        'member_id'      => $trx->member_id,
                        'created_by'     => auth()->id() ?? 1,
                        'receipt_no'     => Receipt::generateReceiptNo(),
                        'amount'         => $paidAmount,
                        'payment_method' => $paymentMethod,
                        'receipt_date'   => $paymentDate,
                    ]);
                }

                $this->logs->log('collect_payment', $trx, $oldTrxData, $trx->fresh()->toArray());
                $this->notifications->send($trx->member_id, 'Payment Received', "Received payment of BDT {$paidAmount} for {$trx->month}.", 'payment');

                return [
                    'message'       => 'Payment fully collected and recorded successfully.',
                    'receipt'       => $receipt,
                    'is_partial'    => false,
                    'paid_amount'   => $paidAmount,
                    'remaining_due' => 0,
                    'transaction'   => $trx->fresh(['member.memberProfile', 'creator.role', 'updater.role', 'receipt']),
                ];
            }

            // Partial payment:
            // 1. Mark this transaction as paid for the amount collected
            $oldTrxData = $trx->toArray();
            $desc = $trx->month ? "Subscription for {$trx->month}" : ($trx->description ?: 'Assigned Payment');
            $partialPayload = [
                'status'           => 'paid',
                'amount'           => $paidAmount,
                'updated_by'       => auth()->id(),
                'transaction_date' => $paymentDate,
                'description'      => "{$desc} (Partial payment: BDT {$paidAmount} of BDT {$originalAmount})" . ($notes ? " - {$notes}" : ""),
            ];
            if ($trxRef) {
                $partialPayload['member_trx_reference'] = $trxRef;
            }
            $trx->update($partialPayload);

            // 2. Create new pending transaction for the remaining due retaining the same transaction_no
            $remainingTrx = Transaction::create([
                'member_id'        => $trx->member_id,
                'created_by'       => auth()->id() ?? 1,
                'transaction_no'   => $trx->transaction_no,
                'type'             => $trx->type,
                'payment_category' => $trx->payment_category,
                'amount'           => $remainingDue,
                'status'           => 'pending',
                'month'            => $trx->month,
                'transaction_date' => $trx->transaction_date,
                'description'      => "Remaining due for {$desc} (Due: BDT {$remainingDue})" . ($notes ? " - Note: {$notes}" : ""),
            ]);

            if (!empty($data['create_receipt'])) {
                Receipt::create([
                    'transaction_id' => $trx->id,
                    'member_id'      => $trx->member_id,
                    'created_by'     => auth()->id() ?? 1,
                    'receipt_no'     => Receipt::generateReceiptNo(),
                    'amount'         => $paidAmount,
                    'payment_method' => $paymentMethod,
                    'receipt_date'   => $paymentDate,
                ]);
            }

            $this->logs->log('partial_payment', $trx, $oldTrxData, [
                'paid_amount'   => $paidAmount,
                'remaining_due' => $remainingDue,
                'remaining_trx' => $remainingTrx->transaction_no,
            ]);

            $this->notifications->send(
                $trx->member_id,
                'Partial Payment Received',
                "Received BDT {$paidAmount}. BDT {$remainingDue} remains due for {$trx->month}.",
                'payment'
            );

            return [
                'message'       => "Partial payment of BDT {$paidAmount} collected. BDT {$remainingDue} remains pending.",
                'status'        => 'partial',
                'paid_amount'   => $paidAmount,
                'remaining_due' => $remainingDue,
                'transaction'   => $trx->fresh(['member.memberProfile', 'creator.role', 'updater.role', 'receipt']),
                'remaining_trx' => $remainingTrx->load(['member.memberProfile', 'creator.role', 'updater.role']),
            ];
        });
    }

    public function delete(Transaction $trx): void
    {
        $this->logs->log('delete', $trx, $trx->toArray(), null);
        $trx->delete();
        $this->notifications->sendToAdmins('Transaction Deleted', "Transaction {$trx->transaction_no} was deleted.", 'transaction');
    }
}

