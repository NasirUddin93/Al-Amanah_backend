<?php

namespace App\Services;

use App\Models\ProfileShare;
use App\Models\User;
use App\Services\Concerns\ResolvesSharedMembers;

class ProfileShareService
{
    use ResolvesSharedMembers;

    public function __construct(
        protected ActivityLogService $logs,
        protected NotificationService $notifications,
    ) {}

    public function list(User $user)
    {
        $query = ProfileShare::with([
            'primaryUser.memberProfile',
            'primaryUser.role',
            'sharedUser.memberProfile',
            'sharedUser.role',
        ])->latest('id');

        return $user->hasAnyRole(['super_admin', 'admin', 'accountant'])
            ? $query->get()
            : $query->where(fn ($q) => $q->where('primary_user_id', $user->id)->orWhere('shared_user_id', $user->id))->get();
    }

    public function create(array $data): ProfileShare
    {
        $memberIds = [];
        if (!empty($data['member_ids']) && is_array($data['member_ids'])) {
            $memberIds = array_map('intval', $data['member_ids']);
        } elseif (!empty($data['primary_user_id']) && !empty($data['shared_user_ids']) && is_array($data['shared_user_ids'])) {
            $memberIds = array_merge([(int) $data['primary_user_id']], array_map('intval', $data['shared_user_ids']));
        } elseif (!empty($data['primary_user_id']) && !empty($data['shared_user_id'])) {
            $memberIds = [(int) $data['primary_user_id'], (int) $data['shared_user_id']];
        }

        $memberIds = array_values(array_unique(array_filter($memberIds)));

        abort_if(count($memberIds) < 2, 422, 'Please select at least 2 different members to merge.');

        $users = User::with('role')->whereIn('id', $memberIds)->get();
        abort_if($users->count() !== count($memberIds), 422, 'One or more selected members could not be found.');

        foreach ($users as $u) {
            abort_if(
                $u->role?->name !== 'member',
                422,
                "Account merging is only allowed for Members. User '{$u->name}' is not a Member."
            );
        }

        $primaryId = !empty($data['primary_user_id']) && in_array((int) $data['primary_user_id'], $memberIds)
            ? (int) $data['primary_user_id']
            : $memberIds[0];

        $status = $data['status'] ?? 'active';
        $relation = $data['relation'] ?? 'Merged';
        $groupName = !empty($data['group_name']) ? trim($data['group_name']) : null;

        $lastShare = null;

        // Connect the primaryId with all other members in the group
        foreach ($memberIds as $targetId) {
            if ($targetId === $primaryId) {
                continue;
            }

            $u1 = min($primaryId, $targetId);
            $u2 = max($primaryId, $targetId);

            $lastShare = ProfileShare::updateOrCreate(
                [
                    'primary_user_id' => $u1,
                    'shared_user_id'  => $u2,
                ],
                [
                    'relation'   => $relation,
                    'group_name' => $groupName,
                    'status'     => $status,
                ]
            );

            $this->logs->log('create', $lastShare, null, $lastShare->toArray());
            $this->notifications->send($targetId, 'Accounts Merged', 'Your account has been merged into a member group.', 'profile');
            $this->notifications->send($primaryId, 'Accounts Merged', 'Your account has been merged into a member group.', 'profile');
        }

        // If a group_name was supplied, update all connected shares in this cluster
        if ($groupName && $primaryUser = User::find($primaryId)) {
            $connectedIds = $this->visibleMemberIds($primaryUser);
            ProfileShare::whereIn('primary_user_id', $connectedIds)
                ->whereIn('shared_user_id', $connectedIds)
                ->update(['group_name' => $groupName]);
        }

        return $lastShare->load([
            'primaryUser.memberProfile',
            'primaryUser.role',
            'sharedUser.memberProfile',
            'sharedUser.role',
        ]);
    }

    public function update(ProfileShare $share, array $data): ProfileShare
    {
        $updateData = [];

        if (isset($data['status'])) {
            $updateData['status'] = $data['status'];
        }

        if (array_key_exists('group_name', $data)) {
            $groupName = !empty($data['group_name']) ? trim($data['group_name']) : null;
            $updateData['group_name'] = $groupName;

            // Propagate group_name across all shares within the connected group cluster
            if ($primaryUser = $share->primaryUser) {
                $connectedIds = $this->visibleMemberIds($primaryUser);
                ProfileShare::whereIn('primary_user_id', $connectedIds)
                    ->whereIn('shared_user_id', $connectedIds)
                    ->update(['group_name' => $groupName]);
            }
        }

        if (!empty($updateData)) {
            $share->update($updateData);
            $this->logs->log('update', $share);
        }

        return $share->load([
            'primaryUser.memberProfile',
            'primaryUser.role',
            'sharedUser.memberProfile',
            'sharedUser.role',
        ]);
    }

    public function updateStatus(ProfileShare $share, string $status): ProfileShare
    {
        return $this->update($share, ['status' => $status]);
    }

    public function delete(ProfileShare $share): void
    {
        $this->logs->log('delete', $share);
        $share->delete();
    }
}
