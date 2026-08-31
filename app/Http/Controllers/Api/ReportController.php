<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\TransactionCollection;
use App\Models\Fdr;
use App\Models\MeetingExpense;
use App\Models\Receipt;
use App\Models\Transaction;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

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

    /**
     * Real-time aggregate statistics for executive dashboard and receipts control.
     */
    public function stats(Request $request): JsonResponse
    {
        $transactions = Transaction::with('member')->get();
        $receipts = Receipt::all();
        $activeMembers = User::whereHas('role', fn ($q) => $q->where('name', 'member'))->count();
        $totalUsers = User::count();
        $totalExpenses = (float) MeetingExpense::sum('amount');
        $totalFdrs = (float) Fdr::where('status', 'active')->sum('amount');

        $totalClearedAmount = 0;
        $clearedReceiptsCount = 0;
        $partialCount = 0;
        $partialCollectedAmount = 0;
        $receivedSlipsCount = 0;
        $receivedSlipsAmount = 0;
        $duePendingCount = 0;
        $duePendingAmount = 0;
        $rejectedSlipsCount = 0;
        $rejectedSlipsAmount = 0;

        // Group transactions by member + month (or description) to evaluate each demand's current state
        $demandMap = [];
        foreach ($transactions as $trx) {
            $mId = $trx->member_id ?: "anon_{$trx->id}";
            $demandKey = $mId . '___' . strtolower(trim($trx->month ?: ($trx->description ?: 'general')));
            if (!isset($demandMap[$demandKey])) {
                $demandMap[$demandKey] = [];
            }
            $demandMap[$demandKey][] = $trx;
        }

        foreach ($demandMap as $trxList) {
            usort($trxList, function ($a, $b) {
                $dateA = $a->updated_at ?: ($a->created_at ?: $a->transaction_date);
                $dateB = $b->updated_at ?: ($b->created_at ?: $b->transaction_date);
                return strcmp((string)$dateB, (string)$dateA) ?: ($b->id <=> $a->id);
            });

            $paidList = array_filter($trxList, fn ($t) => $t->status === 'paid');
            $pendingList = array_filter($trxList, fn ($t) => $t->status === 'pending');
            $rejectedList = array_filter($trxList, fn ($t) => $t->status === 'rejected');

            $isFullyPaid = count($paidList) > 0 && count($pendingList) === 0;
            $isSlipReceived = !$isFullyPaid && count(array_filter($pendingList, fn ($t) => !empty($t->receipt_photo))) > 0;
            $isPartial = !$isSlipReceived && count($paidList) > 0 && count($pendingList) > 0;
            $isRejectedActive = !$isFullyPaid && !$isPartial && !$isSlipReceived && count($rejectedList) > 0;

            $demandPaidTotal = array_sum(array_map(fn ($t) => (float) $t->amount, $paidList));
            $demandPendingTotal = array_sum(array_map(fn ($t) => (float) $t->amount, $pendingList));
            $demandRejectedTotal = array_sum(array_map(fn ($t) => (float) $t->amount, $rejectedList));

            $totalClearedAmount += $demandPaidTotal;

            if ($isFullyPaid) {
                $clearedReceiptsCount += 1;
            } elseif ($isPartial) {
                $partialCount += 1;
                $partialCollectedAmount += $demandPaidTotal;
                $duePendingAmount += $demandPendingTotal;
            } elseif ($isSlipReceived) {
                $receivedSlipsCount += 1;
                $receivedSlipsAmount += $demandPendingTotal;
                $duePendingAmount += $demandPendingTotal;
            } elseif ($isRejectedActive) {
                $rejectedSlipsCount += 1;
                $rejectedSlipsAmount += $demandRejectedTotal;
                $duePendingAmount += ($demandPendingTotal ?: $demandRejectedTotal);
            } else {
                $duePendingCount += 1;
                $duePendingAmount += $demandPendingTotal;
            }
        }

        $totalDemandsCount = count($demandMap);
        $totalDueRemainingCount = max(0, $totalDemandsCount - $clearedReceiptsCount);

        return response()->json([
            'success' => true,
            'data' => [
                'total_transactions' => count($transactions),
                'total_demands' => $totalDemandsCount,
                'total_collections' => $totalClearedAmount,
                'total_receipts' => count($receipts),
                'cleared_receipts_count' => $clearedReceiptsCount,
                'cleared_receipts_amount' => $totalClearedAmount,
                'partial_count' => $partialCount,
                'partial_collected_amount' => $partialCollectedAmount,
                'received_slips_count' => $receivedSlipsCount,
                'received_slips_amount' => $receivedSlipsAmount,
                'due_pending_count' => $totalDueRemainingCount,
                'due_pending_amount' => $duePendingAmount,
                'pure_unpaid_due_count' => $duePendingCount,
                'rejected_slips_count' => $rejectedSlipsCount,
                'rejected_slips_amount' => $rejectedSlipsAmount,
                'pending_slips' => $receivedSlipsCount,
                'pending_slips_amount' => $receivedSlipsAmount,
                'active_members' => $activeMembers,
                'total_users' => $totalUsers,
                'total_expenses' => $totalExpenses,
                'total_fdrs' => $totalFdrs,
            ],
        ]);
    }
}
