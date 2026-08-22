<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class FdrResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'            => $this->id,
            'fdr_no'        => $this->fdr_no,
            'amount'        => (float) $this->amount,
            'start_date'    => $this->start_date,
            'maturity_date' => $this->maturity_date,
            'status'        => $this->status,
            'member'        => $this->whenLoaded('member', fn () => [
                'id'   => $this->member->id,
                'name' => $this->member->name,
            ]),
        ];
    }
}
