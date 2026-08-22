<?php

namespace Database\Seeders;

use App\Models\Permission;
use App\Models\Role;
use Illuminate\Database\Seeder;

class PermissionSeeder extends Seeder
{
    public function run(): void
    {
        $permissions = collect([
            ['module' => 'users', 'action' => 'manage'],
            ['module' => 'transactions', 'action' => 'view'],
            ['module' => 'transactions', 'action' => 'manage'],
            ['module' => 'receipts', 'action' => 'manage'],
            ['module' => 'reports', 'action' => 'print'],
            ['module' => 'settings', 'action' => 'manage'],
        ])->map(fn ($p) => Permission::firstOrCreate($p));

        $superAdmin = Role::where('name', 'super_admin')->first();
        $superAdmin?->permissions()->sync($permissions->pluck('id'));

        $admin = Role::where('name', 'admin')->first();
        $admin?->permissions()->sync(
            $permissions->whereIn('module', ['transactions', 'reports'])->pluck('id')
        );

        $accountant = Role::where('name', 'accountant')->first();
        $accountant?->permissions()->sync(
            $permissions->where('module', 'receipts')->pluck('id')
        );
    }
}
