<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('roles', function (Blueprint $t) {
            $t->id();
            $t->string('name', 50)->unique();
            $t->string('description')->nullable();
            $t->timestamp('created_at')->useCurrent();
            $t->timestamp('deleted_at')->nullable();
        });

        Schema::create('users', function (Blueprint $t) {
            $t->id();
            $t->foreignId('role_id')->constrained('roles')->restrictOnDelete();
            $t->string('name', 100);
            $t->string('email', 150)->unique();
            $t->string('password');
            $t->string('designation', 100)->nullable();
            $t->boolean('is_active')->default(true);
            $t->timestamps();
            $t->softDeletes();
        });

        Schema::create('permissions', function (Blueprint $t) {
            $t->id();
            $t->string('module', 50);
            $t->string('action', 50);
            $t->string('description')->nullable();
            $t->unique(['module', 'action']);
        });

        Schema::create('role_permissions', function (Blueprint $t) {
            $t->id();
            $t->foreignId('role_id')->constrained()->cascadeOnDelete();
            $t->foreignId('permission_id')->constrained()->cascadeOnDelete();
            $t->unique(['role_id', 'permission_id']);
        });

        Schema::create('admin_payment_permissions', function (Blueprint $t) {
            $t->id();
            $t->foreignId('admin_user_id')->unique()->constrained('users')->restrictOnDelete();
            $t->foreignId('assigned_by')->constrained('users')->restrictOnDelete();
            $t->boolean('can_change_payment')->default(false);
            $t->timestamp('created_at')->useCurrent();
        });

        Schema::create('user_profiles', function (Blueprint $t) {
            $t->id();
            $t->foreignId('user_id')->unique()->constrained()->restrictOnDelete();
            $t->string('member_no', 50)->unique();
            $t->string('phone', 30)->nullable();
            $t->text('address')->nullable();
            $t->decimal('share_amount', 12, 2)->default(0);
            $t->timestamp('created_at')->useCurrent();
            $t->softDeletes();
        });

        Schema::create('transactions', function (Blueprint $t) {
            $t->id();
            $t->foreignId('member_id')->constrained('users')->restrictOnDelete();
            $t->foreignId('created_by')->constrained('users')->restrictOnDelete();
            $t->foreignId('updated_by')->nullable()->constrained('users')->nullOnDelete();
            $t->string('transaction_no', 50)->unique();
            $t->enum('type', ['payment', 'share', 'fdr', 'expense', 'other'])->default('payment');
            $t->string('payment_category', 50)->default('general');
            $t->decimal('amount', 12, 2)->default(0);
            $t->string('status', 20)->default('paid');
            $t->string('month', 50)->nullable();
            $t->date('transaction_date');
            $t->text('description')->nullable();
            $t->timestamps();
            $t->softDeletes();
            $t->index('transaction_date');
        });

        Schema::create('receipts', function (Blueprint $t) {
            $t->id();
            $t->foreignId('transaction_id')->unique()->constrained()->restrictOnDelete();
            $t->foreignId('member_id')->constrained('users')->restrictOnDelete();
            $t->foreignId('created_by')->constrained('users')->restrictOnDelete();
            $t->string('receipt_no', 50)->unique();
            $t->decimal('amount', 12, 2)->default(0);
            $t->enum('payment_method', ['cash', 'bank', 'mobile_banking', 'other'])->default('cash');
            $t->date('receipt_date');
            $t->timestamp('created_at')->useCurrent();
            $t->softDeletes();
        });

        Schema::create('meeting_expenses', function (Blueprint $t) {
            $t->id();
            $t->foreignId('created_by')->constrained('users')->restrictOnDelete();
            $t->string('title', 150);
            $t->date('expense_date');
            $t->decimal('amount', 12, 2)->default(0);
            $t->text('description')->nullable();
            $t->timestamp('created_at')->useCurrent();
            $t->softDeletes();
        });

        Schema::create('fdrs', function (Blueprint $t) {
            $t->id();
            $t->foreignId('member_id')->constrained('users')->restrictOnDelete();
            $t->foreignId('created_by')->constrained('users')->restrictOnDelete();
            $t->string('fdr_no', 50)->unique();
            $t->decimal('amount', 12, 2)->default(0);
            $t->date('start_date');
            $t->date('maturity_date')->nullable();
            $t->enum('status', ['active', 'closed', 'cancelled'])->default('active');
            $t->timestamp('created_at')->useCurrent();
            $t->softDeletes();
        });

        Schema::create('notifications', function (Blueprint $t) {
            $t->id();
            $t->foreignId('user_id')->constrained()->cascadeOnDelete();
            $t->string('title', 150);
            $t->text('message');
            $t->string('type', 50)->default('system');
            $t->boolean('is_read')->default(false);
            $t->timestamp('created_at')->useCurrent();
        });

        Schema::create('activity_logs', function (Blueprint $t) {
            $t->id();
            $t->foreignId('user_id')->nullable()->constrained()->nullOnDelete();
            $t->string('action', 50);
            $t->string('table_name', 100);
            $t->unsignedInteger('record_id')->nullable();
            $t->json('old_values')->nullable();
            $t->json('new_values')->nullable();
            $t->string('ip_address', 45)->nullable();
            $t->timestamp('created_at')->useCurrent();
        });

        Schema::create('settings', function (Blueprint $t) {
            $t->id();
            $t->foreignId('updated_by')->nullable()->constrained('users')->nullOnDelete();
            $t->string('setting_key', 100)->unique();
            $t->string('setting_value');
            $t->string('description')->nullable();
            $t->timestamp('updated_at')->useCurrent();
        });

        Schema::create('profile_shares', function (Blueprint $t) {
            $t->id();
            $t->foreignId('primary_user_id')->constrained('users')->cascadeOnDelete();
            $t->foreignId('shared_user_id')->constrained('users')->cascadeOnDelete();
            $t->string('relation', 50);
            $t->enum('status', ['active', 'inactive'])->default('active');
            $t->timestamp('created_at')->useCurrent();
            $t->unique(['primary_user_id', 'shared_user_id']);
        });
    }

    public function down(): void
    {
        collect(['profile_shares','settings','activity_logs','notifications','fdrs','meeting_expenses',
            'receipts','transactions','user_profiles','admin_payment_permissions','role_permissions',
            'permissions','users','roles'])
            ->each(fn ($table) => Schema::dropIfExists($table));
    }
};
