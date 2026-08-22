<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('transactions', function (Blueprint $table) {
            $table->longText('receipt_photo')->nullable()->after('description');
            $table->timestamp('receipt_photo_uploaded_at')->nullable()->after('receipt_photo');
            $table->foreignId('receipt_photo_uploaded_by')->nullable()->constrained('users')->nullOnDelete()->after('receipt_photo_uploaded_at');
        });
    }

    public function down(): void
    {
        Schema::table('transactions', function (Blueprint $table) {
            $table->dropConstrainedForeignId('receipt_photo_uploaded_by');
            $table->dropColumn(['receipt_photo', 'receipt_photo_uploaded_at']);
        });
    }
};
