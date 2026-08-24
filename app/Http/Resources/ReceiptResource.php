<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ReceiptResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'             => $this->id,
            'receipt_no'     => $this->receipt_no,
            'amount'         => (float) $this->amount,
            'payment_method' => $this->payment_method,
            'receipt_date'   => $this->receipt_date,
            'member'         => $this->whenLoaded('member', fn () => [
                'id'        => $this->member->id,
                'name'      => $this->member->name,
                'member_no' => $this->member->memberProfile?->member_no,
            ]),
            'transaction'    => $this->whenLoaded('transaction', fn () => [
                'id'                        => $this->transaction->id,
                'transaction_no'            => $this->transaction->transaction_no,
                'description'               => $this->transaction->description,
                'month'                     => $this->transaction->month,
                'receipt_photo'             => $this->transaction->receipt_photo,
                'receipt_photo_uploaded_at' => $this->transaction->receipt_photo_uploaded_at,
            ]),
            'created_at'     => $this->created_at,
        ];
    }
}
