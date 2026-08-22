<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreReceiptRequest;
use App\Http\Resources\ReceiptResource;
use App\Models\Receipt;
use App\Services\ReceiptService;
use Illuminate\Http\Request;

class ReceiptController extends Controller
{
    public function __construct(protected ReceiptService $service) {}

    public function index(Request $request)
    {
        return ReceiptResource::collection($this->service->list($request->user()));
    }

    public function store(StoreReceiptRequest $request)
    {
        return new ReceiptResource($this->service->create($request->validated()));
    }

    public function update(Request $request, Receipt $receipt)
    {
        $data = $request->validate([
            'amount'         => ['sometimes', 'numeric', 'min:0'],
            'payment_method' => ['sometimes', 'in:cash,bank,mobile_banking,other'],
            'receipt_date'   => ['sometimes', 'date'],
        ]);

        return new ReceiptResource($this->service->update($receipt, $data));
    }

    public function destroy(Receipt $receipt)
    {
        $this->service->delete($receipt);

        return response()->json(['message' => 'Receipt deleted (soft).']);
    }
}
