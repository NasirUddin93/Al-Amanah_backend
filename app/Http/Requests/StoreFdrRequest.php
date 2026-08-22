<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreFdrRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'member_id'     => ['required', 'exists:users,id'],
            'amount'        => ['required', 'numeric', 'min:0'],
            'start_date'    => ['required', 'date'],
            'maturity_date' => ['nullable', 'date', 'after_or_equal:start_date'],
            'status'        => ['nullable', Rule::in(['active', 'closed', 'cancelled'])],
        ];
    }
}
