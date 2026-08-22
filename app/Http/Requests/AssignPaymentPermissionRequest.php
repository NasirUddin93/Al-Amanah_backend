<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class AssignPaymentPermissionRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'admin_user_id'      => ['required', 'exists:users,id'],
            'can_change_payment' => ['required', 'boolean'],
        ];
    }
}
