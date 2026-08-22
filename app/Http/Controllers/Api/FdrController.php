<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreFdrRequest;
use App\Http\Resources\FdrResource;
use App\Models\Fdr;
use App\Services\FdrService;
use Illuminate\Http\Request;

class FdrController extends Controller
{
    public function __construct(protected FdrService $service) {}

    public function index(Request $request)
    {
        return FdrResource::collection($this->service->list($request->user()));
    }

    public function store(StoreFdrRequest $request)
    {
        return new FdrResource($this->service->create($request->validated()));
    }

    public function update(Request $request, Fdr $fdr)
    {
        $data = $request->validate([
            'amount'        => ['sometimes', 'numeric', 'min:0'],
            'maturity_date' => ['nullable', 'date'],
            'status'        => ['sometimes', 'in:active,closed,cancelled'],
        ]);

        return new FdrResource($this->service->update($fdr, $data));
    }

    public function destroy(Fdr $fdr)
    {
        $this->service->delete($fdr);

        return response()->json(['message' => 'FDR deleted (soft).']);
    }
}
