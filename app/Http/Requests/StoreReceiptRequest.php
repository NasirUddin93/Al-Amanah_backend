<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreReceiptRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'transaction_id' => ['required', 'exists:transactions,id', 'unique:receipts,transaction_id'],
            'member_id'      => ['nullable', 'exists:users,id'],
            'amount'         => ['required', 'numeric', 'min:0'],
            'payment_method' => ['required', Rule::in(['cash', 'bank', 'mobile_banking', 'other'])],
            'receipt_date'   => ['required', 'date'],
        ];
    }
}
