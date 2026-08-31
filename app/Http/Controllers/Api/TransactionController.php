<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreTransactionRequest;
use App\Http\Requests\UpdateTransactionRequest;
use App\Http\Resources\TransactionCollection;
use App\Http\Resources\TransactionResource;
use App\Models\Transaction;
use App\Services\Concerns\ResolvesSharedMembers;
use App\Services\NotificationService;
use App\Services\TransactionService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class TransactionController extends Controller
{
    use ResolvesSharedMembers;

    public function __construct(
        protected TransactionService $service,
        protected NotificationService $notifications,
    ) {}

    public function index(Request $request)
    {
        return new TransactionCollection($this->service->list($request->user()));
    }

    public function show(Request $request, Transaction $transaction)
    {
        return new TransactionResource($this->service->find($request->user(), $transaction));
    }

    public function store(StoreTransactionRequest $request)
    {
        return new TransactionResource($this->service->create($request->validated()));
    }

    public function generatePayments(Request $request)
    {
        $data = $request->validate([
            'payment_category' => ['required', 'in:monthly_payment,one_time'],
            'member_ids'       => ['required', 'array'],
            'amount'           => ['required', 'numeric', 'min:0.01'],
            'months'           => ['nullable', 'array'],
            'title'            => ['nullable', 'string', 'max:150'],
            'due_date'         => ['nullable', 'date'],
            'description'      => ['nullable', 'string'],
            'transaction_no'   => ['nullable', 'string', 'max:100', 'unique:transactions,transaction_no'],
        ], [
            'transaction_no.unique' => 'The Transaction ID has already been taken. Please choose a unique Transaction ID.',
        ]);

        $result = $this->service->generatePayments($data);

        return response()->json($result);
    }

    public function update(UpdateTransactionRequest $request, Transaction $transaction)
    {
        return new TransactionResource($this->service->update($transaction, $request->validated()));
    }

    public function collectPayment(Request $request, Transaction $transaction)
    {
        $data = $request->validate([
            'paid_amount'           => ['nullable', 'numeric', 'min:0.01'],
            'amount'                => ['nullable', 'numeric', 'min:0.01'],
            'payment_method'        => ['nullable', 'string', 'in:cash,bank,mobile_banking,other'],
            'payment_date'          => ['nullable', 'date'],
            'notes'                 => ['nullable', 'string', 'max:255'],
            'reference'             => ['nullable', 'string', 'max:255'],
            'trx_reference'         => ['nullable', 'string', 'max:255'],
            'transaction_reference' => ['nullable', 'string', 'max:255'],
            'create_receipt'        => ['nullable', 'boolean'],
        ]);

        $result = $this->service->collectPayment($transaction, $data, $request->user());

        return response()->json($result);
    }

    public function uploadReceiptPhoto(Request $request, Transaction $transaction)
    {
        $user = $request->user();
        // Allow the member or their merged / linked family accounts (e.g. husband/wife) to upload payment proof and pay on behalf
        $allowedMemberIds = $this->visibleMemberIds($user);
        if (!in_array($transaction->member_id, $allowedMemberIds, true) && !$user->hasAnyRole(['admin', 'super_admin', 'accountant'])) {
            return response()->json(['message' => 'You are not authorized to upload receipt photo for this member.'], 403);
        }

        $maxAmount = (float) $transaction->amount;
        $request->validate([
            'photo'          => ['nullable', 'image', 'max:10240'],
            'photo_data'     => ['nullable', 'string'],
            'paid_amount'    => ['nullable', 'numeric', 'min:0.01', "max:{$maxAmount}"],
            'trx_reference'  => ['required', 'string', 'max:100'],
            'payment_method' => ['nullable', 'string', 'in:cash,bank,mobile_banking,other'],
            'comment'        => ['nullable', 'string', 'max:1000'],
        ], [
            'paid_amount.max'        => "Paid amount cannot exceed the remaining due of BDT " . number_format($maxAmount, 2),
            'trx_reference.required' => "Please enter the Transaction Reference Code / TrxID.",
        ]);

        $updateData = [
            'receipt_photo_uploaded_at' => now(),
            'receipt_photo_uploaded_by' => auth()->id(),
        ];

        if ($request->hasFile('photo')) {
            $path = $request->file('photo')->store('receipts', 'public');
            $updateData['receipt_photo'] = asset('storage/' . $path);
        } elseif ($request->filled('photo_data')) {
            $photoData = $request->input('photo_data');
            
            // Check if photo_data is a Base64 Data URL (data:image/...;base64,...)
            if (preg_match('/^data:image\/(\w+);base64,/', $photoData, $matches)) {
                $ext = strtolower($matches[1]);
                if (!in_array($ext, ['jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp'])) {
                    $ext = 'png';
                }
                $base64Raw = substr($photoData, strpos($photoData, ',') + 1);
                $decoded = base64_decode($base64Raw);
                if ($decoded !== false) {
                    $fileName = 'receipt_' . $transaction->id . '_' . time() . '_' . uniqid() . '.' . $ext;
                    Storage::disk('public')->put('receipts/' . $fileName, $decoded);
                    $updateData['receipt_photo'] = asset('storage/receipts/' . $fileName);
                }
            } elseif (filter_var($photoData, FILTER_VALIDATE_URL) || str_starts_with($photoData, '/storage/')) {
                $updateData['receipt_photo'] = $photoData;
            }
        }

        if ($request->filled('paid_amount')) {
            $updateData['member_paid_amount'] = $request->input('paid_amount');
        }
        if ($request->filled('trx_reference')) {
            $ref = trim($request->input('trx_reference'));
            if ($ref !== '') {
                // Check if this reference code has already been used on another non-rejected transaction across all members
                $existingTrx = Transaction::where('id', '!=', $transaction->id)
                    ->where('member_trx_reference', $ref)
                    ->where('status', '!=', 'rejected')
                    ->first();

                if ($existingTrx) {
                    $ownerName = $existingTrx->member ? $existingTrx->member->name : 'another member';
                    $itemLabel = $existingTrx->month ?: $existingTrx->transaction_no;
                    throw \Illuminate\Validation\ValidationException::withMessages([
                        'trx_reference' => ["The Transaction Reference / TrxID '{$ref}' has already been submitted for {$ownerName} ({$itemLabel}). Reference IDs must be unique across all active payments unless the previous submission was rejected."],
                    ]);
                }
                $updateData['member_trx_reference'] = $ref;
            }
        }
        if ($request->filled('payment_method')) {
            $updateData['member_payment_method'] = $request->input('payment_method');
        }
        if ($request->filled('comment')) {
            $updateData['member_comment'] = $request->input('comment');
        }

        $transaction->update($updateData);

        $memberName = $transaction->member ? $transaction->member->name : 'A member';
        $itemMonth = $transaction->month ?: $transaction->transaction_no;
        $submittedAmount = !empty($updateData['member_paid_amount']) ? ' (BDT ' . number_format($updateData['member_paid_amount']) . ')' : '';

        $this->notifications->sendToStaff(
            'New Proof Slip Submitted',
            "{$memberName} submitted a payment proof slip{$submittedAmount} for {$itemMonth} for verification.",
            'receipt'
        );

        return response()->json([
            'message'     => 'Payment proof and receipt slip submitted successfully.',
            'transaction' => new TransactionResource($transaction->fresh(['member.memberProfile', 'creator.role', 'updater.role', 'receipt'])),
        ]);
    }

    /**
     * Admin rejects submitted payment receipt proof.
     * The existing row is marked as 'rejected' with the rejection reason preserved.
     * A brand new pending transaction row is automatically generated for the member.
     */
    public function rejectReceiptPhoto(Request $request, Transaction $transaction)
    {
        $user = $request->user();
        if (!$user->hasAnyRole(['admin', 'super_admin', 'accountant'])) {
            return response()->json(['message' => 'Unauthorized. Only Admins and Accountants can reject payment receipts.'], 403);
        }

        $request->validate([
            'reason' => 'nullable|string|max:500',
        ]);

        $reason = $request->input('reason', 'Payment proof slip could not be verified by Admin. Please re-upload a valid proof.');

        // 1. Mark existing transaction as 'rejected' and record rejection reason
        $transaction->update([
            'status'           => 'rejected',
            'rejection_reason' => $reason,
            'updated_by'       => $user->id,
        ]);

        // 2. Automatically generate a new pending transaction row for the member retaining the demand transaction_no
        $newPendingTrx = Transaction::create([
            'member_id'        => $transaction->member_id,
            'created_by'       => $user->id,
            'updated_by'       => null,
            'transaction_no'   => $transaction->transaction_no,
            'type'             => $transaction->type,
            'payment_category' => $transaction->payment_category,
            'amount'           => $transaction->amount,
            'status'           => 'pending',
            'month'            => $transaction->month,
            'transaction_date' => $transaction->transaction_date ?? now()->toDateString(),
            'description'      => $transaction->description,
        ]);

        // 3. Notify the member
        if ($transaction->member_id) {
            \App\Models\Notification::create([
                'user_id'    => $transaction->member_id,
                'title'      => 'Payment Proof Slip Rejected',
                'message'    => "Your payment proof for {$transaction->transaction_no}" . ($transaction->month ? " ({$transaction->month})" : "") . " was rejected by admin. Reason: {$reason}. A new pending due ({$newPendingTrx->transaction_no}) has been generated for you to submit a valid slip.",
                'type'       => 'alert',
                'is_read'    => false,
            ]);
        }

        return response()->json([
            'message'             => 'Payment proof slip rejected. A new pending due row has been automatically generated for the member.',
            'rejected_transaction'=> new TransactionResource($transaction->fresh(['member.memberProfile', 'creator.role', 'updater.role', 'receipt'])),
            'new_transaction'     => new TransactionResource($newPendingTrx->fresh(['member.memberProfile', 'creator.role', 'updater.role', 'receipt'])),
        ]);
    }

    /**
     * Batch upload: 1 slip for multiple pending transactions (merged members).
     * Accepts multiple transaction IDs with one shared photo + TrxID.
     */
    public function batchUploadReceiptPhoto(Request $request)
    {
        $user = $request->user();
        $allowedMemberIds = $this->visibleMemberIds($user);

        $request->validate([
            'transaction_ids'   => ['required', 'array', 'min:1', 'max:20'],
            'transaction_ids.*' => ['required', 'integer'],
            'photo_data'        => ['nullable', 'string'],
            'photo'             => ['nullable', 'image', 'max:10240'],
            'trx_reference'     => ['required', 'string', 'max:100'],
            'payment_method'    => ['nullable', 'string', 'in:cash,bank,mobile_banking,other'],
            'comment'           => ['nullable', 'string', 'max:1000'],
            'allocations'       => ['nullable', 'array'],
            'allocations.*.transaction_id' => ['required_with:allocations', 'integer'],
            'allocations.*.paid_amount'    => ['required_with:allocations', 'numeric', 'min:0.01'],
        ], [
            'trx_reference.required' => 'Please enter the Transaction Reference Code / TrxID.',
        ]);

        $transactionIds = $request->input('transaction_ids');
        $transactions = Transaction::whereIn('id', $transactionIds)->get();

        if ($transactions->count() !== count($transactionIds)) {
            return response()->json(['message' => 'One or more transaction IDs are invalid.'], 422);
        }

        // Validate ownership and eligibility
        foreach ($transactions as $trx) {
            if (!in_array($trx->member_id, $allowedMemberIds, true) && !$user->hasAnyRole(['admin', 'super_admin', 'accountant'])) {
                return response()->json(['message' => "You are not authorized to upload receipt photo for transaction #{$trx->transaction_no}."], 403);
            }
            if ($trx->status !== 'pending') {
                return response()->json(['message' => "Transaction #{$trx->transaction_no} is not pending and cannot accept a slip upload."], 422);
            }
            if ($trx->receipt_photo) {
                return response()->json(['message' => "Transaction #{$trx->transaction_no} already has a receipt photo submitted."], 422);
            }
        }

        // Build allocations map
        $allocations = collect($request->input('allocations', []))->keyBy('transaction_id');

        // Store the photo once
        $photoUrl = null;
        if ($request->hasFile('photo')) {
            $path = $request->file('photo')->store('receipts', 'public');
            $photoUrl = asset('storage/' . $path);
        } elseif ($request->filled('photo_data')) {
            $photoData = $request->input('photo_data');
            if (preg_match('/^data:image\/(\w+);base64,/', $photoData, $matches)) {
                $ext = strtolower($matches[1]);
                if (!in_array($ext, ['jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp'])) {
                    $ext = 'png';
                }
                $base64Raw = substr($photoData, strpos($photoData, ',') + 1);
                $decoded = base64_decode($base64Raw);
                if ($decoded !== false) {
                    $fileName = 'batch_receipt_' . $user->id . '_' . time() . '_' . uniqid() . '.' . $ext;
                    Storage::disk('public')->put('receipts/' . $fileName, $decoded);
                    $photoUrl = asset('storage/receipts/' . $fileName);
                }
            } elseif (filter_var($photoData, FILTER_VALIDATE_URL) || str_starts_with($photoData, '/storage/')) {
                $photoUrl = $photoData;
            }
        }

        $baseRef = trim($request->input('trx_reference'));
        $paymentMethod = $request->input('payment_method');
        $comment = $request->input('comment');
        $totalCount = $transactions->count();
        $totalAmount = 0;
        $memberNames = [];
        $months = [];

        \DB::transaction(function () use ($transactions, $photoUrl, $baseRef, $paymentMethod, $comment, $allocations, $totalCount, &$totalAmount, &$memberNames, &$months, $user) {
            $index = 0;
            foreach ($transactions as $trx) {
                $index++;
                // Build indexed TrxID suffix for traceability
                $ref = $totalCount > 1 ? "{$baseRef} [{$index}/{$totalCount}]" : $baseRef;

                $paidAmount = $allocations->has($trx->id)
                    ? $allocations[$trx->id]['paid_amount']
                    : $trx->amount;

                $trx->update([
                    'receipt_photo'             => $photoUrl,
                    'receipt_photo_uploaded_at'  => now(),
                    'receipt_photo_uploaded_by'  => $user->id,
                    'member_paid_amount'        => $paidAmount,
                    'member_trx_reference'      => $ref,
                    'member_payment_method'     => $paymentMethod,
                    'member_comment'            => $comment,
                ]);

                $totalAmount += (float) $paidAmount;
                if ($trx->member && !in_array($trx->member->name, $memberNames)) {
                    $memberNames[] = $trx->member->name;
                }
                if ($trx->month && !in_array($trx->month, $months)) {
                    $months[] = $trx->month;
                }
            }
        });

        // Send one consolidated notification
        $namesStr = implode(', ', $memberNames) ?: 'A member';
        $monthsStr = implode(', ', $months);
        $this->notifications->sendToStaff(
            'Combined Proof Slip Submitted',
            "{$namesStr} submitted a combined payment slip (BDT " . number_format($totalAmount) . ") covering {$totalCount} dues" . ($monthsStr ? " ({$monthsStr})" : '') . " for verification.",
            'receipt'
        );

        return response()->json([
            'message'      => "Payment proof submitted successfully for {$totalCount} transactions.",
            'transactions' => TransactionResource::collection(
                $transactions->fresh(['member.memberProfile', 'creator.role', 'updater.role', 'receipt'])
            ),
        ]);
    }

    public function destroy(Transaction $transaction)
    {
        $this->service->delete($transaction);

        return response()->json(['message' => 'Transaction deleted (soft).']);
    }
}


