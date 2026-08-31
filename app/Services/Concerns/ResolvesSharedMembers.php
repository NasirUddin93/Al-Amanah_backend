<?php

namespace App\Services\Concerns;

use App\Models\ProfileShare;
use App\Models\User;

trait ResolvesSharedMembers
{
    /** Member's own id + all transitively merged member ids (supports 2, 3, 4, 5+ members). */
    protected function visibleMemberIds(User $user): array
    {
        $allActiveShares = ProfileShare::where('status', 'active')->get(['primary_user_id', 'shared_user_id']);

        $adjacency = [];
        foreach ($allActiveShares as $share) {
            $u1 = (int) $share->primary_user_id;
            $u2 = (int) $share->shared_user_id;
            $adjacency[$u1][] = $u2;
            $adjacency[$u2][] = $u1;
        }

        $visited = [];
        $queue = [(int) $user->id];
        $visited[(int) $user->id] = true;

        while (!empty($queue)) {
            $curr = array_shift($queue);
            foreach ($adjacency[$curr] ?? [] as $neighbor) {
                if (!isset($visited[$neighbor])) {
                    $visited[$neighbor] = true;
                    $queue[] = $neighbor;
                }
            }
        }

        return array_keys($visited);
    }
}
