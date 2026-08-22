<?php

namespace Database\Seeders;

use App\Models\Role;
use Illuminate\Database\Seeder;

class RoleSeeder extends Seeder
{
    public function run(): void
    {
        collect([
            ['name' => 'super_admin', 'description' => 'Full control. Assigns roles, designations, and payment permissions.'],
            ['name' => 'admin', 'description' => 'Views all transactions, prints reports, receives notifications.'],
            ['name' => 'accountant', 'description' => 'Views and manages member receipts.'],
            ['name' => 'member', 'description' => 'Views own profile, transactions, and notifications.'],
        ])->each(fn ($role) => Role::firstOrCreate(['name' => $role['name']], $role));
    }
}
