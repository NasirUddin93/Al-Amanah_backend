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
        $query = Transaction::with(['member.memberProfile', 'creator.role', 'updater.role', 'receipt']);

        if ($user->isMember()) {
            $query->whereIn('member_id', $this->visibleMemberIds($user));
        }

        return $query
            ->when(request('status'), fn ($q, $s) => $q->where('status', $s))
            ->when(request('payment_category'), fn ($q, $c) => $q->where('payment_category', $c))
            ->when(request('member_id'), fn ($q, $m) => $q->where('member_id', $m))
            ->when(request('type'), fn ($q, $t) => $q->where('type', $t))
            ->latest('transaction_date')
            ->paginate((int) request('per_page', 15));
    }

    public function find(User $user, Transaction $transaction): Transaction
    {
        if ($user->isMember()) {
            abort_unless(in_array($transaction->member_id, $this->visibleMemberIds($user), true), 404);
        }

        return $transaction->load(['member.memberProfile', 'creator.role', 'updater.role', 'receipt']);
    }

    public function create(array $data): Transaction
    {
        return DB::transaction(function () use ($data) {
            $data['transaction_no'] = Transaction::generateTransactionNo();
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

            $createdTransactions = [];

            foreach ($memberIds as $memberId) {
                if ($paymentType === 'monthly_payment' && !empty($months)) {
                    foreach ($months as $monthName) {
                        // Skip if the member already has an active (pending or paid) record for this month
                        $alreadyExists = Transaction::where('member_id', $memberId)
                            ->where('payment_category', 'monthly_payment')
                            ->where('month', $monthName)
                            ->whereIn('status', ['pending', 'paid'])
                            ->exists();

                        if ($alreadyExists) {
                            continue;
                        }

                        $trx = Transaction::create([
                            'member_id'        => $memberId,
                            'created_by'       => auth()->id() ?? 1,
                            'transaction_no'   => Transaction::generateTransactionNo(),
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
                    }
                } else {
                    $trx = Transaction::create([
                        'member_id'        => $memberId,
                        'created_by'       => auth()->id() ?? 1,
                        'transaction_no'   => Transaction::generateTransactionNo(),
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
                }
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

    public function collectPayment(Transaction $trx, array $data): array
    {
        return DB::transaction(function () use ($trx, $data) {
            $paidAmount = (float) $data['paid_amount'];
            $originalAmount = (float) $trx->amount;
            $remainingDue = max(0, round($originalAmount - $paidAmount, 2));
            $paymentMethod = $data['payment_method'] ?? 'cash';
            $paymentDate = $data['payment_date'] ?? now()->toDateString();
            $notes = $data['notes'] ?? null;

            // Full payment (paid amount >= original amount)
            if ($remainingDue <= 0) {
                $trx->update([
                    'status'           => 'paid',
                    'amount'           => $paidAmount,
                    'updated_by'       => auth()->id(),
                    'transaction_date' => $paymentDate,
                    'description'      => $notes ? ($trx->description ? "{$trx->description} - {$notes}" : $notes) : $trx->description,
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

                $this->logs->log('collect_payment', $trx, ['status' => 'pending'], $trx->toArray());
                $this->notifications->send(
                    $trx->member_id,
                    'Payment Cleared',
                    "Payment of BDT {$paidAmount} for {$trx->month} has been cleared in full.",
                    'payment'
                );

                return [
                    'message'       => 'Full payment collected successfully.',
                    'status'        => 'paid',
                    'paid_amount'   => $paidAmount,
                    'remaining_due' => 0,
                    'transaction'   => $trx->fresh(['member.memberProfile', 'creator.role', 'updater.role', 'receipt']),
                ];
            }

            // Partial payment:
            // 1. Mark this transaction as paid for the amount collected
            $oldTrxData = $trx->toArray();
            $desc = $trx->month ? "Subscription for {$trx->month}" : ($trx->description ?: 'Assigned Payment');
            $trx->update([
                'status'           => 'paid',
                'amount'           => $paidAmount,
                'updated_by'       => auth()->id(),
                'transaction_date' => $paymentDate,
                'description'      => "{$desc} (Partial payment: BDT {$paidAmount} of BDT {$originalAmount})" . ($notes ? " - {$notes}" : ""),
            ]);

            // 2. Create new pending transaction for the remaining due
            $remainingTrx = Transaction::create([
                'member_id'        => $trx->member_id,
                'created_by'       => auth()->id() ?? 1,
                'transaction_no'   => Transaction::generateTransactionNo(),
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

