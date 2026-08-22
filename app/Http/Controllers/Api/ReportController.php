<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\TransactionCollection;
use App\Models\Transaction;

class ReportController extends Controller
{
    /** Printable transaction report data (Admin / Super Admin). */
    public function transactions()
    {
        return new TransactionCollection(
            Transaction::with(['member.memberProfile', 'creator', 'receipt'])
                ->when(request('from'), fn ($q, $d) => $q->whereDate('transaction_date', '>=', $d))
                ->when(request('to'), fn ($q, $d) => $q->whereDate('transaction_date', '<=', $d))
                ->when(request('type'), fn ($q, $t) => $q->where('type', $t))
                ->orderBy('transaction_date')
                ->paginate((int) request('per_page', 1000))
        );
    }
}
