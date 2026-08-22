<?php

namespace App\Services;

use App\Models\Fdr;
use App\Models\User;
use App\Services\Concerns\ResolvesSharedMembers;

class FdrService
{
    use ResolvesSharedMembers;

    public function __construct(
        protected ActivityLogService $logs,
        protected NotificationService $notifications,
    ) {}

    public function list(User $user)
    {
        $query = Fdr::with(['member.memberProfile', 'creator']);

        if ($user->isMember()) $query->whereIn('member_id', $this->visibleMemberIds($user));

        return $query->latest('start_date')->paginate(15);
    }

    public function create(array $data): Fdr
    {
        $data['fdr_no']     = 'FDR-' . now()->format('Ymd') . '-' . str_pad((string) (Fdr::withTrashed()->count() + 1), 5, '0', STR_PAD_LEFT);
        $data['created_by'] = auth()->id();

        $fdr = Fdr::create($data);

        $this->logs->log('create', $fdr, null, $fdr->toArray());
        $this->notifications->send($fdr->member_id, 'New FDR', "FDR {$fdr->fdr_no} of {$fdr->amount} created.", 'fdr');

        return $fdr;
    }

    public function update(Fdr $fdr, array $data): Fdr
    {
        $old = $fdr->toArray();
        $fdr->update($data);
        $this->logs->log('update', $fdr, $old, $fdr->toArray());

        return $fdr;
    }

    public function delete(Fdr $fdr): void
    {
        $this->logs->log('delete', $fdr, $fdr->toArray(), null);
        $fdr->delete();
    }
}
