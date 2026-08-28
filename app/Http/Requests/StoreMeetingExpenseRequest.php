<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreMeetingExpenseRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'title'        => ['required', 'string', 'max:150'],
            'expense_date' => ['nullable', 'date'],
            'amount'       => ['required', 'numeric', 'min:0'],
            'description'  => ['nullable', 'string'],
        ];
    }

    protected function prepareForValidation(): void
    {
        if (empty($this->expense_date)) {
            $this->merge(['expense_date' => now()->toDateString()]);
        }
    }
}
