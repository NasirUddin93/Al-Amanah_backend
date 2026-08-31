<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class TransactionResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        $lastModifier = $this->updater ?? $this->creator;

        return [
            'id'               => $this->id,
            'transaction_no'   => $this->transaction_no,
            'type'             => $this->type,
            'payment_category' => $this->payment_category ?? 'general',
            'amount'           => (float) $this->amount,
            'status'           => $this->status ?? 'paid',
            'month'            => $this->month,
            'transaction_date' => $this->transaction_date ? (is_string($this->transaction_date) ? $this->transaction_date : $this->transaction_date->format('Y-m-d')) : null,
            'description'      => $this->description,
            'member'           => $this->whenLoaded('member', fn () => [
                'id'           => $this->member->id,
                'name'         => $this->member->name,
                'member_no'    => $this->member->memberProfile?->member_no,
            ]),
            'created_by'       => $this->whenLoaded('creator', fn () => $this->creator ? [
                'id'           => $this->creator->id,
                'name'         => $this->creator->name,
                'role'         => $this->creator->role?->name ?? 'admin',
                'member_no'    => $this->creator->memberProfile?->member_no,
            ] : null),
            'updated_by'       => $this->whenLoaded('updater', fn () => $this->updater ? [
                'id'           => $this->updater->id,
                'name'         => $this->updater->name,
                'role'         => $this->updater->role?->name ?? 'admin',
                'member_no'    => $this->updater->memberProfile?->member_no,
            ] : null),
            'last_modified_by' => $lastModifier ? [
                'id'           => $lastModifier->id,
                'name'         => $lastModifier->name,
                'role'         => $lastModifier->role?->name ?? 'admin',
                'member_no'    => $lastModifier->memberProfile?->member_no,
                'action'       => $this->updated_by ? 'Updated' : 'Created',
            ] : null,
            'receipt'                   => $this->whenLoaded('receipt'),
            'receipt_photo'             => $this->receipt_photo,
            'receipt_photo_uploaded_at' => $this->receipt_photo_uploaded_at ? (is_string($this->receipt_photo_uploaded_at) ? $this->receipt_photo_uploaded_at : $this->receipt_photo_uploaded_at->format('Y-m-d H:i')) : null,
            'member_paid_amount'        => $this->member_paid_amount !== null ? (float) $this->member_paid_amount : null,
            'member_trx_reference'      => $this->member_trx_reference,
            'member_payment_method'     => $this->member_payment_method,
            'member_comment'            => $this->member_comment,
            'rejection_reason'          => $this->rejection_reason,
            'created_at'                => $this->created_at ? $this->created_at->format('Y-m-d H:i') : null,
            'updated_at'                => $this->updated_at ? $this->updated_at->format('Y-m-d H:i') : null,
        ];
    }
}
