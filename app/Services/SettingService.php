<?php

namespace App\Services;

use App\Models\Setting;
use App\Models\User;

class SettingService
{
    public function __construct(
        protected ActivityLogService $logs,
        protected NotificationService $notifications,
    ) {}

    public function updatePaymentValue(User $user, string $key, string $value): Setting
    {
        // Only Super Admin or an Admin with permission can change payment values
        abort_unless($user->isSuperAdmin() || $user->canChangePayment(), 403, 'You are not allowed to change payment values.');

        $setting = Setting::updateOrCreate(
            ['setting_key' => $key],
            ['setting_value' => $value, 'updated_by' => $user->id]
        );

        // Keep legacy and modern setting keys synchronized
        if ($key === 'monthly_subscription_default') {
            Setting::updateOrCreate(['setting_key' => 'payment_amount_1'], ['setting_value' => $value, 'updated_by' => $user->id]);
        } elseif ($key === 'payment_amount_1') {
            Setting::updateOrCreate(['setting_key' => 'monthly_subscription_default'], ['setting_value' => $value, 'updated_by' => $user->id]);
        } elseif ($key === 'one_time_payment_default') {
            Setting::updateOrCreate(['setting_key' => 'payment_amount_2'], ['setting_value' => $value, 'updated_by' => $user->id]);
        } elseif ($key === 'payment_amount_2') {
            Setting::updateOrCreate(['setting_key' => 'one_time_payment_default'], ['setting_value' => $value, 'updated_by' => $user->id]);
        }

        $this->logs->log('update', $setting);
        $this->notifications->sendToAdmins('Payment Value Updated', "{$key} changed to {$value}.", 'setting');

        return $setting;
    }
}
