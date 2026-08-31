<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreProfileShareRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'primary_user_id'   => ['nullable', 'exists:users,id'],
            'shared_user_id'    => ['nullable', 'exists:users,id'],
            'shared_user_ids'   => ['nullable', 'array'],
            'shared_user_ids.*' => ['exists:users,id'],
            'member_ids'        => ['nullable', 'array', 'min:2'],
            'member_ids.*'      => ['exists:users,id'],
            'relation'          => ['nullable', 'string', 'max:50'],
            'group_name'        => ['nullable', 'string', 'max:100'],
            'status'            => ['nullable', Rule::in(['active', 'inactive'])],
        ];
    }
}
