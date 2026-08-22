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
            'primary_user'  => $this->whenLoaded('primaryUser', fn () => ['id' => $this->primaryUser->id, 'name' => $this->primaryUser->name]),
            'shared_user'   => $this->whenLoaded('sharedUser', fn () => ['id' => $this->sharedUser->id, 'name' => $this->sharedUser->name]),
            'relation'      => $this->relation,
            'status'        => $this->status,
        ];
    }
}
