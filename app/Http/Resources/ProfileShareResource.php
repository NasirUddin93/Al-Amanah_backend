<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProfileShareResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'            => $this->id,
            'primary_user'  => $this->primaryUser ? [
                'id'        => $this->primaryUser->id,
                'name'      => $this->primaryUser->name,
                'email'     => $this->primaryUser->email,
                'member_no' => $this->primaryUser->memberProfile?->member_no,
                'role'      => $this->primaryUser->role?->name,
            ] : null,
            'shared_user'   => $this->sharedUser ? [
                'id'        => $this->sharedUser->id,
                'name'      => $this->sharedUser->name,
                'email'     => $this->sharedUser->email,
                'member_no' => $this->sharedUser->memberProfile?->member_no,
                'role'      => $this->sharedUser->role?->name,
            ] : null,
            'primary_user_id' => $this->primary_user_id,
            'shared_user_id'  => $this->shared_user_id,
            'relation'        => $this->relation,
            'group_name'      => $this->group_name,
            'status'          => $this->status,
            'created_at'      => $this->created_at ? $this->created_at->toISOString() : null,
        ];
    }
}
