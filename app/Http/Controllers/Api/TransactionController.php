<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreTransactionRequest;
use App\Http\Requests\UpdateTransactionRequest;
use App\Http\Resources\TransactionCollection;
use App\Http\Resources\TransactionResource;
use App\Models\Transaction;
use App\Services\TransactionService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class TransactionController extends Controller
{
    public function __construct(protected TransactionService $service) {}

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
            'transaction_no'   => ['nullable', 'string', 'max:100'],
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
            'paid_amount'    => ['required', 'numeric', 'min:0.01'],
            'payment_method' => ['nullable', 'string', 'in:cash,bank,mobile_banking,other'],
            'payment_date'   => ['nullable', 'date'],
            'notes'          => ['nullable', 'string', 'max:255'],
            'reference'      => ['nullable', 'string', 'max:255'],
            'trx_reference'  => ['nullable', 'string', 'max:255'],
            'create_receipt' => ['nullable', 'boolean'],
        ]);

        $result = $this->service->collectPayment($transaction, $data);

        return response()->json($result);
    }

    public function uploadReceiptPhoto(Request $request, Transaction $transaction)
    {
        // Only the member owning this transaction can upload receipt photos & submit payment proof
        if ($transaction->member_id !== $request->user()->id) {
            return response()->json(['message' => 'Only the member can upload their receipt photo.'], 403);
        }

        $maxAmount = (float) $transaction->amount;
        $request->validate([
            'photo'          => ['nullable', 'image', 'max:10240'],
            'photo_data'     => ['nullable', 'string'],
            'paid_amount'    => ['nullable', 'numeric', 'min:0.01', "max:{$maxAmount}"],
            'trx_reference'  => ['nullable', 'string', 'max:100'],
            'payment_method' => ['nullable', 'string', 'in:cash,bank,mobile_banking,other'],
            'comment'        => ['nullable', 'string', 'max:1000'],
        ], [
            'paid_amount.max' => "Paid amount cannot exceed the remaining due of BDT " . number_format($maxAmount, 2),
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
            $updateData['member_trx_reference'] = $request->input('trx_reference');
        }
        if ($request->filled('payment_method')) {
            $updateData['member_payment_method'] = $request->input('payment_method');
        }
        if ($request->filled('comment')) {
            $updateData['member_comment'] = $request->input('comment');
        }

        $transaction->update($updateData);

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
        if (!$user->hasAnyRole(['admin', 'super_admin'])) {
            return response()->json(['message' => 'Unauthorized. Only Admins can reject payment receipts.'], 403);
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

    public function destroy(Transaction $transaction)
    {
        $this->service->delete($transaction);

        return response()->json(['message' => 'Transaction deleted (soft).']);
    }
}


