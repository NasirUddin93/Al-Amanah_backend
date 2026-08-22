<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class TransactionCollection extends ResourceCollection
{
    public $collects = TransactionResource::class;

    public function toArray(Request $request): array
    {
        return [
            'data'    => $this->collection,
            'summary' => [
                'page_total' => $this->collection->sum('amount'),
                'count'      => $this->collection->count(),
            ],
        ];
    }
}
