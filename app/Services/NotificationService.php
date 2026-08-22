<?php

namespace App\Services;

use App\Models\Notification as NotificationModel;
use App\Models\User;
use Illuminate\Support\Facades\DB;

class NotificationService
{
    public function send(int $userId, string $title, string $message, string $type = 'system'): void
    {
        NotificationModel::create([
            'user_id' => $userId,
            'title'   => $title,
            'message' => $message,
            'type'    => $type,
        ]);
    }

    public function sendToRoles(array $roleNames, string $title, string $message, string $type = 'system'): void
    {
        $rows = User::whereHas('role', fn ($q) => $q->whereIn('name', $roleNames))
            ->pluck('id')
            ->map(fn ($id) => [
                'user_id'    => $id,
                'title'      => $title,
                'message'    => $message,
                'type'       => $type,
                'created_at' => now(),
            ])->all();

        if ($rows) DB::table('notifications')->insert($rows);
    }

    public function sendToAdmins(string $title, string $message, string $type = 'system'): void
    {
        $this->sendToRoles(['super_admin', 'admin'], $title, $message, $type);
    }
}
