<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateUserRequest extends FormRequest
{
    public function rules(): array
    {
        $id = $this->route('user')->id;

        return [
            'name'                 => ['sometimes', 'string', 'max:100'],
            'email'                => ['sometimes', 'email', Rule::unique('users', 'email')->ignore($id)],
            'password'             => ['sometimes', 'string', 'min:8'],
            'role_id'              => ['sometimes', 'exists:roles,id'],
            'designation'          => ['nullable', 'string', 'max:100'],
            'can_change_payment'   => ['nullable', 'boolean'],
            'is_active'            => ['sometimes', 'boolean'],
            'profile.member_no'    => ['nullable', 'string', 'max:50'],
            'profile.phone'        => ['nullable', 'string', 'max:30'],
            'profile.address'      => ['nullable', 'string'],
            'profile.id_photo'     => ['nullable'],
            'profile.id_photos'    => ['nullable', 'array'],
            'profile.id_photos.*'  => ['nullable', 'string'],
            'profile.share_amount' => ['nullable', 'numeric', 'min:0'],
        ];
    }
}
