<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ActivityLogResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'          => $this->id,
            'action'      => $this->action,
            'table_name'  => $this->table_name,
            'record_id'   => $this->record_id,
            'old_values'  => $this->old_values,
            'new_values'  => $this->new_values,
            'ip_address'  => $this->ip_address,
            'user_id'     => $this->user_id,
            'user'        => $this->whenLoaded('user', fn () => $this->user ? [
                'id'          => $this->user->id,
                'name'        => $this->user->name,
                'email'       => $this->user->email,
                'role'        => $this->user->role?->name,
                'designation' => $this->user->designation,
            ] : null),
            'user_name'   => $this->user?->name ?? 'System Action',
            'created_at'  => $this->created_at?->toISOString() ?? (string) $this->created_at,
        ];
    }
}
