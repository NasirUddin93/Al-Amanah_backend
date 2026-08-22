<?php

namespace Database\Seeders;

use App\Models\Setting;
use Illuminate\Database\Seeder;

class SettingSeeder extends Seeder
{
    public function run(): void
    {
        Setting::firstOrCreate(['setting_key' => 'payment_amount_1'], ['setting_value' => '2000', 'description' => 'Default payment amount option 1']);
        Setting::firstOrCreate(['setting_key' => 'payment_amount_2'], ['setting_value' => '3000', 'description' => 'Default payment amount option 2']);
    }
}
