<?php

namespace App\Services;

use App\Models\MeetingExpense;

class MeetingExpenseService
{
    public function __construct(protected ActivityLogService $logs) {}

    public function list()
    {
        return MeetingExpense::with(['creator.memberProfile', 'creator.role'])->latest('expense_date')->paginate(100);
    }

    public function create(array $data): MeetingExpense
    {
        $expense = MeetingExpense::create($data + ['created_by' => auth()->id()]);
        $expense->load(['creator.memberProfile', 'creator.role']);
        $this->logs->log('create', $expense, null, $expense->toArray());

        return $expense;
    }

    public function update(MeetingExpense $expense, array $data): MeetingExpense
    {
        $old = $expense->toArray();
        $expense->update($data);
        $this->logs->log('update', $expense, $old, $expense->toArray());

        return $expense;
    }

    public function delete(MeetingExpense $expense): void
    {
        $this->logs->log('delete', $expense, $expense->toArray(), null);
        $expense->delete();
    }
}
