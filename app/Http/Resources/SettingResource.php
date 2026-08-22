<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class SettingResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'            => $this->id,
            'setting_key'   => $this->setting_key,
            'setting_value' => $this->setting_value,
            'description'   => $this->description,
        ];
    }
}
