<?php

use App\Http\Controllers\Api\ActivityLogController;
use App\Http\Controllers\Api\AdminPermissionController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\FdrController;
use App\Http\Controllers\Api\MeetingExpenseController;
use App\Http\Controllers\Api\NotificationController;
use App\Http\Controllers\Api\ProfileShareController;
use App\Http\Controllers\Api\ReceiptController;
use App\Http\Controllers\Api\ReportController;
use App\Http\Controllers\Api\RoleController;
use App\Http\Controllers\Api\SettingController;
use App\Http\Controllers\Api\TransactionController;
use App\Http\Controllers\Api\UserController;
use Illuminate\Support\Facades\Route;

Route::post('login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {

    // Auth
    Route::post('logout', [AuthController::class, 'logout']);
    Route::get('me', [AuthController::class, 'me']);

    // Notifications (every logged-in user, own only)
    Route::get('notifications', [NotificationController::class, 'index']);
    Route::post('notifications/{notification}/read', [NotificationController::class, 'markRead']);
    Route::post('notifications/read-all', [NotificationController::class, 'markAllRead']);

    // Settings (view for all staff; update only Super Admin or allowed Admin)
    Route::get('settings', [SettingController::class, 'index']);
    Route::put('settings', [SettingController::class, 'update'])
        ->middleware(['role:super_admin,admin', 'payment.permission']);

    // Read lists are role-scoped inside services (member sees own/shared only)
    Route::get('transactions', [TransactionController::class, 'index']);
    Route::get('transactions/{transaction}', [TransactionController::class, 'show']);
    Route::post('transactions/{transaction}/upload-receipt-photo', [TransactionController::class, 'uploadReceiptPhoto']);
    Route::get('receipts', [ReceiptController::class, 'index']);
    Route::get('fdrs', [FdrController::class, 'index']);

    // Transactions & FDRs management (Super Admin + Admin)
    Route::middleware('role:super_admin,admin')->group(function () {
        Route::post('transactions', [TransactionController::class, 'store']);
        Route::post('transactions/generate-payments', [TransactionController::class, 'generatePayments']);
        Route::post('transactions/{transaction}/collect-payment', [TransactionController::class, 'collectPayment']);
        Route::post('transactions/{transaction}/reject-receipt-photo', [TransactionController::class, 'rejectReceiptPhoto']);
        Route::put('transactions/{transaction}', [TransactionController::class, 'update']);

        Route::post('fdrs', [FdrController::class, 'store']);
        Route::put('fdrs/{fdr}', [FdrController::class, 'update']);

        Route::get('reports/transactions', [ReportController::class, 'transactions']);
    });

    // Hard delete transactions: Super Admin only
    Route::delete('transactions/{transaction}', [TransactionController::class, 'destroy'])
        ->middleware('role:super_admin');
    Route::delete('fdrs/{fdr}', [FdrController::class, 'destroy'])->middleware('role:super_admin');

    // Receipts management (Super Admin + Admin + Accountant)
    Route::middleware('role:super_admin,admin,accountant')->group(function () {
        Route::post('receipts', [ReceiptController::class, 'store']);
        Route::put('receipts/{receipt}', [ReceiptController::class, 'update']);
        Route::delete('receipts/{receipt}', [ReceiptController::class, 'destroy']);
    });

    // Meeting expenses (Super Admin + Admin)
    Route::middleware('role:super_admin,admin')->group(function () {
        Route::get('meeting-expenses', [MeetingExpenseController::class, 'index']);
        Route::post('meeting-expenses', [MeetingExpenseController::class, 'store']);
        Route::put('meeting-expenses/{expense}', [MeetingExpenseController::class, 'update']);
        Route::delete('meeting-expenses/{expense}', [MeetingExpenseController::class, 'destroy']);
    });

    // Profile shares (members can view own; Super Admin manages)
    Route::get('profile-shares', [ProfileShareController::class, 'index']);
    Route::middleware('role:super_admin')->group(function () {
        Route::post('profile-shares', [ProfileShareController::class, 'store']);
        Route::put('profile-shares/{profileShare}', [ProfileShareController::class, 'update']);
    });

    // Super Admin only area
    Route::middleware('role:super_admin')->group(function () {
        Route::apiResource('users', UserController::class);
        Route::post('users/{user}/assign-role', [UserController::class, 'assignRole']);
        Route::apiResource('roles', RoleController::class);
        Route::get('permissions', [RoleController::class, 'permissions']);
        Route::get('admin-payment-permissions', [AdminPermissionController::class, 'index']);
        Route::post('admin-payment-permissions', [AdminPermissionController::class, 'store']);
        Route::put('admin-payment-permissions', [AdminPermissionController::class, 'update']);
        Route::get('activity-logs', [ActivityLogController::class, 'index']);
    });
});
