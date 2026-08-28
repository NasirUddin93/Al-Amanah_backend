<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class MeetingExpenseResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'            => $this->id,
            'title'         => $this->title,
            'expense_date'  => $this->expense_date ? $this->expense_date->format('Y-m-d') : now()->toDateString(),
            'created_at'    => $this->created_at ? $this->created_at->format('Y-m-d H:i:s') : null,
            'amount'        => (float) $this->amount,
            'description'   => $this->description,
            'created_by'    => $this->creator ? $this->creator->name : null,
            'created_by_id' => $this->created_by,
            'creator'       => $this->creator ? [
                'id'        => $this->creator->id,
                'name'      => $this->creator->name,
                'email'     => $this->creator->email,
                'member_no' => $this->creator->memberProfile?->member_no ?? null,
                'role'      => $this->creator->role?->name ?? null,
            ] : null,
        ];
    }
}
