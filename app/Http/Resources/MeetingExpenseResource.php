<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class MeetingExpenseResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'           => $this->id,
            'title'        => $this->title,
            'expense_date' => $this->expense_date,
            'amount'       => (float) $this->amount,
            'description'  => $this->description,
            'created_by'   => $this->whenLoaded('creator', fn () => $this->creator->name),
        ];
    }
}
