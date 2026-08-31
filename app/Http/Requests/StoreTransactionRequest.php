<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreTransactionRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'member_id'        => ['required', 'exists:users,id'],
            'type'             => ['required', Rule::in(['payment', 'share', 'fdr', 'expense', 'other'])],
            'amount'           => ['required', 'numeric', 'min:0'],
            'transaction_date' => ['required', 'date'],
            'description'      => ['nullable', 'string'],
            'transaction_no'   => ['nullable', 'string', 'max:100', 'unique:transactions,transaction_no'],
        ];
    }

    public function messages(): array
    {
        return [
            'transaction_no.unique' => 'The Transaction ID has already been taken. Please choose a unique Transaction ID.',
        ];
    }
}
