<?php

namespace App\Services;

use App\Models\ProfileShare;
use App\Models\User;

class ProfileShareService
{
    public function __construct(
        protected ActivityLogService $logs,
        protected NotificationService $notifications,
    ) {}

    public function list(User $user)
    {
        return $user->isSuperAdmin()
            ? ProfileShare::with(['primaryUser', 'sharedUser'])->paginate(15)
            : ProfileShare::with(['primaryUser', 'sharedUser'])
                ->where('primary_user_id', $user->id)->orWhere('shared_user_id', $user->id)
                ->paginate(15);
    }

    public function create(array $data): ProfileShare
    {
        abort_if($data['primary_user_id'] === $data['shared_user_id'], 422, 'Cannot share profile with the same user.');

        $share = ProfileShare::create($data);

        $this->logs->log('create', $share, null, $share->toArray());
        $this->notifications->send($data['shared_user_id'], 'Profile Shared', 'Your profile has been shared with a family member.', 'profile');

        return $share->load('primaryUser', 'sharedUser');
    }

    public function updateStatus(ProfileShare $share, string $status): ProfileShare
    {
        $share->update(['status' => $status]);
        $this->logs->log('update', $share);

        return $share;
    }
}
