<?php

namespace Database\Seeders;

use App\Models\Receipt;
use App\Models\Transaction;
use Illuminate\Database\Seeder;

class SyncReceiptsSeeder extends Seeder
{
    public function run(): void
    {
        $paidTransactions = Transaction::where('status', 'paid')
            ->whereDoesntHave('receipt')
            ->get();

        foreach ($paidTransactions as $t) {
            Receipt::create([
                'transaction_id' => $t->id,
                'member_id'      => $t->member_id,
                'created_by'     => $t->created_by ?? 1,
                'receipt_no'     => Receipt::generateReceiptNo(),
                'amount'         => $t->amount,
                'payment_method' => $t->member_payment_method ?? 'cash',
                'receipt_date'   => $t->transaction_date ?? now(),
            ]);
        }
    }
}
