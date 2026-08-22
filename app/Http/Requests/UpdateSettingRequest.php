<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateSettingRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'setting_key'   => ['required', 'string', 'max:100'],
            'setting_value' => ['required', 'string', 'max:255'],
        ];
    }
}
