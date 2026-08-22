<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreMeetingExpenseRequest;
use App\Http\Resources\MeetingExpenseResource;
use App\Models\MeetingExpense;
use App\Services\MeetingExpenseService;
use Illuminate\Http\Request;

class MeetingExpenseController extends Controller
{
    public function __construct(protected MeetingExpenseService $service) {}

    public function index()
    {
        return MeetingExpenseResource::collection($this->service->list());
    }

    public function store(StoreMeetingExpenseRequest $request)
    {
        return new MeetingExpenseResource($this->service->create($request->validated()));
    }

    public function update(Request $request, MeetingExpense $expense)
    {
        $data = $request->validate([
            'title'        => ['sometimes', 'string', 'max:150'],
            'expense_date' => ['sometimes', 'date'],
            'amount'       => ['sometimes', 'numeric', 'min:0'],
            'description'  => ['nullable', 'string'],
        ]);

        return new MeetingExpenseResource($this->service->update($expense, $data));
    }

    public function destroy(MeetingExpense $expense)
    {
        $this->service->delete($expense);

        return response()->json(['message' => 'Meeting expense deleted (soft).']);
    }
}
