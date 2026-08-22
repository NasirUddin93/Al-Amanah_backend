<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateTransactionRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'type'             => ['sometimes', Rule::in(['payment', 'share', 'fdr', 'expense', 'other'])],
            'amount'           => ['sometimes', 'numeric', 'min:0'],
            'transaction_date' => ['sometimes', 'date'],
            'description'      => ['nullable', 'string'],
        ];
    }
}
