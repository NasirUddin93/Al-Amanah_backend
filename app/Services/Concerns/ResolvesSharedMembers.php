<?php

namespace App\Services\Concerns;

use App\Models\ProfileShare;
use App\Models\User;

trait ResolvesSharedMembers
{
    /** Member's own id + shared ids (husband/wife). */
    protected function visibleMemberIds(User $user): array
    {
        $ids = [$user->id];

        $shares = ProfileShare::where('status', 'active')
            ->where(fn ($q) => $q->where('primary_user_id', $user->id)->orWhere('shared_user_id', $user->id))
            ->get();

        foreach ($shares as $share) {
            $ids[] = $share->primary_user_id === $user->id ? $share->shared_user_id : $share->primary_user_id;
        }

        return array_unique($ids);
    }
}
