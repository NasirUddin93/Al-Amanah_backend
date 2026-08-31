<?php

namespace Database\Seeders;

use App\Models\Setting;
use Illuminate\Database\Seeder;

class SettingSeeder extends Seeder
{
    public function run(): void
    {
        Setting::updateOrCreate(
            ['setting_key' => 'monthly_subscription_default'],
            ['setting_value' => '2000', 'description' => 'Default Monthly Subscription / Dues Amount for members (BDT)']
        );
        Setting::updateOrCreate(
            ['setting_key' => 'one_time_payment_default'],
            ['setting_value' => '3000', 'description' => 'Default 1-Time Payment / Special Contribution Amount (BDT)']
        );
        Setting::updateOrCreate(
            ['setting_key' => 'payment_amount_1'],
            ['setting_value' => '2000', 'description' => 'Default payment amount option 1 (Monthly Subscription)']
        );
        Setting::updateOrCreate(
            ['setting_key' => 'payment_amount_2'],
            ['setting_value' => '3000', 'description' => 'Default payment amount option 2 (1-Time Payment)']
        );
    }
}
