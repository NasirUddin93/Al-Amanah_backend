<?php

namespace App\Services;

use App\Models\Receipt;
use App\Models\User;
use App\Services\Concerns\ResolvesSharedMembers;
use Illuminate\Support\Facades\DB;

class ReceiptService
{
    use ResolvesSharedMembers;

    public function __construct(
        protected ActivityLogService $logs,
        protected NotificationService $notifications,
    ) {}

    public function list(User $user)
    {
        $query = Receipt::with(['member.memberProfile', 'transaction', 'creator']);

        if ($user->isMember()) $query->whereIn('member_id', $this->visibleMemberIds($user));

        return $query->latest('receipt_date')->paginate(15);
    }

    public function create(array $data): Receipt
    {
        return DB::transaction(function () use ($data) {
            $data['receipt_no'] = 'RCT-' . now()->format('Ymd') . '-' .
                str_pad((string) (Receipt::withTrashed()->count() + 1), 5, '0', STR_PAD_LEFT);
            $data['created_by'] = auth()->id();
            $data['member_id']  = $data['member_id'] ?? \App\Models\Transaction::find($data['transaction_id'])?->member_id;

            $receipt = Receipt::create($data);

            $this->logs->log('create', $receipt, null, $receipt->toArray());
            $this->notifications->send($receipt->member_id, 'New Receipt',
                "Receipt {$receipt->receipt_no} of {$receipt->amount} issued.", 'receipt');
            $this->notifications->sendToAdmins('New Receipt', "Receipt {$receipt->receipt_no} issued.", 'receipt');

            return $receipt->load('member', 'transaction');
        });
    }

    public function update(Receipt $receipt, array $data): Receipt
    {
        $old = $receipt->toArray();
        $receipt->update($data);
        $this->logs->log('update', $receipt, $old, $receipt->fresh()->toArray());

        return $receipt->fresh(['member', 'transaction']);
    }

    public function delete(Receipt $receipt): void
    {
        $this->logs->log('delete', $receipt, $receipt->toArray(), null);
        $receipt->delete();
    }
}
