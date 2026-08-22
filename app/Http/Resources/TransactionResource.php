<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class TransactionResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'               => $this->id,
            'transaction_no'   => $this->transaction_no,
            'type'             => $this->type,
            'payment_category' => $this->payment_category ?? 'general',
            'amount'           => (float) $this->amount,
            'status'           => $this->status ?? 'paid',
            'month'            => $this->month,
            'transaction_date' => $this->transaction_date,
            'description'      => $this->description,
            'member'           => $this->whenLoaded('member', fn () => [
                'id'           => $this->member->id,
                'name'         => $this->member->name,
                'member_no'    => $this->member->memberProfile?->member_no,
            ]),
            'created_by'       => $this->whenLoaded('creator', fn () => $this->creator->name),
            'receipt'          => $this->whenLoaded('receipt'),
            'created_at'       => $this->created_at,
        ];
    }
}
