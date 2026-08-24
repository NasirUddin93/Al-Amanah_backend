<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('transactions', function (Blueprint $table) {
            $table->decimal('member_paid_amount', 12, 2)->nullable()->after('receipt_photo_uploaded_at');
            $table->string('member_trx_reference', 100)->nullable()->after('member_paid_amount');
            $table->string('member_payment_method', 50)->nullable()->after('member_trx_reference');
            $table->text('member_comment')->nullable()->after('member_payment_method');
        });
    }

    public function down(): void
    {
        Schema::table('transactions', function (Blueprint $table) {
            $table->dropColumn([
                'member_paid_amount',
                'member_trx_reference',
                'member_payment_method',
                'member_comment',
            ]);
        });
    }
};
