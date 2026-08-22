<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreUserRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'name'                 => ['required', 'string', 'max:100'],
            'email'                => ['required', 'email', 'unique:users,email'],
            'password'             => ['required', 'string', 'min:8'],
            'role_id'              => ['required', 'exists:roles,id'],
            'designation'          => ['nullable', 'string', 'max:100'],
            'can_change_payment'   => ['nullable', 'boolean'],
            'profile.member_no'    => ['nullable', 'string', 'max:50', 'unique:user_profiles,member_no'],
            'profile.phone'        => ['nullable', 'string', 'max:30'],
            'profile.address'      => ['nullable', 'string'],
            'profile.share_amount' => ['nullable', 'numeric', 'min:0'],
        ];
    }
}
