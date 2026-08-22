<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class AdminPaymentPermissionResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'                 => $this->id,
            'admin'              => $this->whenLoaded('admin', fn () => [
                'id'   => $this->admin->id,
                'name' => $this->admin->name,
            ]),
            'can_change_payment' => $this->can_change_payment,
            'assigned_by'        => $this->whenLoaded('assignedBy', fn () => $this->assignedBy?->name),
            'created_at'         => $this->created_at,
        ];
    }
}
