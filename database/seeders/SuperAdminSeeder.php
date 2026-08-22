<?php

namespace Database\Seeders;

use App\Models\Role;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class SuperAdminSeeder extends Seeder
{
    public function run(): void
    {
        $superAdminRole = Role::where('name', 'super_admin')->first();

        User::firstOrCreate(
            ['email' => 'superadmin@alamanah.com'],
            [
                'name'     => 'Super Admin',
                'role_id'  => $superAdminRole ? $superAdminRole->id : 1,
                'password' => Hash::make('11111111'),
                'is_active' => true,
            ]
        );
    }
}
