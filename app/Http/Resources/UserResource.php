<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'                 => $this->id,
            'name'               => $this->name,
            'email'              => $this->email,
            'designation'        => $this->designation,
            'is_active'          => (bool) $this->is_active,
            'can_change_payment' => $this->isSuperAdmin() ? true : (bool) ($this->adminPaymentPermission?->can_change_payment ?? false),
            'role'               => $this->role ? [
                'id'   => $this->role->id,
                'name' => $this->role->name,
            ] : null,
            'member_profile'     => $this->memberProfile,
            'created_at'         => $this->created_at,
            'updated_at'         => $this->updated_at,
        ];
    }
}
