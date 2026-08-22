<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreMeetingExpenseRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'title'        => ['required', 'string', 'max:150'],
            'expense_date' => ['required', 'date'],
            'amount'       => ['required', 'numeric', 'min:0'],
            'description'  => ['nullable', 'string'],
        ];
    }
}
