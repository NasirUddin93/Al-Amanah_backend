<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Role;
use App\Models\MemberProfile;
use Illuminate\Support\Facades\Hash;

class MemberAtoFSeeder extends Seeder
{
    public function run(): void
    {
        $memberRole = Role::where('name', 'member')->first();

        $members = [
            ['name' => 'A Member', 'email' => 'a@g.com'],
            ['name' => 'B Member', 'email' => 'b@g.com'],
            ['name' => 'C Member', 'email' => 'c@g.com'],
            ['name' => 'D Member', 'email' => 'd@g.com'],
            ['name' => 'E Member', 'email' => 'e@g.com'],
            ['name' => 'F Member', 'email' => 'f@g.com'],
        ];

        foreach ($members as $m) {
            $user = User::updateOrCreate(
                ['email' => strtolower($m['email'])],
                [
                    'name' => $m['name'],
                    'password' => Hash::make('11111111'),
                    'role_id' => $memberRole->id,
                    'is_active' => true,
                ]
            );

            if (!$user->memberProfile()->exists()) {
                $user->memberProfile()->create([
                    'member_no' => MemberProfile::generateMemberId(),
                    'share_amount' => 5000,
                    'phone' => '0170000000' . rand(1, 9),
                    'address' => 'Dhaka, Bangladesh',
                ]);
            }

            $user->refresh();
            $memberNo = $user->memberProfile ? $user->memberProfile->member_no : 'N/A';
            echo "Created/Updated: {$user->name} ({$user->email}) - ID: {$memberNo}\n";
        }
    }
}
