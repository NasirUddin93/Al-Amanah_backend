<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreProfileShareRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'primary_user_id' => ['required', 'exists:users,id'],
            'shared_user_id'  => ['required', 'exists:users,id', 'different:primary_user_id'],
            'relation'        => ['required', 'string', 'max:50'],
            'status'          => ['nullable', Rule::in(['active', 'inactive'])],
        ];
    }
}
