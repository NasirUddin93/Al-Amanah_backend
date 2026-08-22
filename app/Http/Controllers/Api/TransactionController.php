<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreTransactionRequest;
use App\Http\Requests\UpdateTransactionRequest;
use App\Http\Resources\TransactionCollection;
use App\Http\Resources\TransactionResource;
use App\Models\Transaction;
use App\Services\TransactionService;
use Illuminate\Http\Request;

class TransactionController extends Controller
{
    public function __construct(protected TransactionService $service) {}

    public function index(Request $request)
    {
        return new TransactionCollection($this->service->list($request->user()));
    }

    public function show(Request $request, Transaction $transaction)
    {
        return new TransactionResource($this->service->find($request->user(), $transaction));
    }

    public function store(StoreTransactionRequest $request)
    {
        return new TransactionResource($this->service->create($request->validated()));
    }

    public function generatePayments(Request $request)
    {
        $data = $request->validate([
            'payment_category' => ['required', 'in:monthly_payment,one_time'],
            'member_ids'       => ['required', 'array'],
            'amount'           => ['required', 'numeric', 'min:0.01'],
            'months'           => ['nullable', 'array'],
            'title'            => ['nullable', 'string', 'max:150'],
            'due_date'         => ['nullable', 'date'],
            'description'      => ['nullable', 'string'],
        ]);

        $result = $this->service->generatePayments($data);

        return response()->json($result);
    }

    public function update(UpdateTransactionRequest $request, Transaction $transaction)
    {
        return new TransactionResource($this->service->update($transaction, $request->validated()));
    }

    public function destroy(Transaction $transaction)
    {
        $this->service->delete($transaction);

        return response()->json(['message' => 'Transaction deleted (soft).']);
    }
}
