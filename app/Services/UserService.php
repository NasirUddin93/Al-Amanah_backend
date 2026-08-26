<?php

namespace App\Services;

use App\Models\AdminPaymentPermission;
use App\Models\MemberProfile;
use App\Models\Role;
use App\Models\User;
use Illuminate\Support\Arr;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class UserService
{
    public function __construct(
        protected ActivityLogService $logs,
        protected NotificationService $notifications,
    ) {}

    public function list()
    {
        $sortBy = request('sort_by', 'created_at');
        $sortOrder = strtolower(request('sort_order', 'desc')) === 'asc' ? 'asc' : 'desc';

        return User::with(['role', 'memberProfile', 'adminPaymentPermission'])
            ->when(request('search'), function ($q, $s) {
                $q->where(function ($sub) use ($s) {
                    $sub->where('name', 'like', "%{$s}%")
                        ->orWhere('email', 'like', "%{$s}%")
                        ->orWhere('designation', 'like', "%{$s}%")
                        ->orWhereHas('memberProfile', function ($p) use ($s) {
                            $p->where('member_no', 'like', "%{$s}%")
                              ->orWhere('phone', 'like', "%{$s}%");
                        });
                });
            })
            ->when(request('role_id'), fn ($q, $r) => $q->where('role_id', $r))
            ->when(request('status') !== null && request('status') !== '', function ($q) {
                $status = request('status');
                if ($status === 'active' || $status === '1') {
                    $q->where('is_active', true);
                } elseif ($status === 'inactive' || $status === '0') {
                    $q->where('is_active', false);
                }
            })
            ->when(in_array($sortBy, ['name', 'email', 'created_at', 'updated_at', 'is_active', 'designation']), function ($q) use ($sortBy, $sortOrder) {
                $q->orderBy($sortBy, $sortOrder);
            }, function ($q) {
                $q->latest();
            })
            ->paginate((int) request('per_page', 15));
    }

    public function create(array $data): User
    {
        $role = isset($data['role_id']) ? Role::find($data['role_id']) : null;
        if ($role && $role->name === 'super_admin') {
            throw ValidationException::withMessages([
                'role_id' => 'Creating additional Super Admin accounts is not permitted.',
            ]);
        }

        return DB::transaction(function () use ($data, $role) {
            $profile = Arr::pull($data, 'profile');
            $canChangePayment = Arr::pull($data, 'can_change_payment');
            $isAdmin = $role && $role->name === 'admin';

            // Designation and payment modifications are ONLY for Admin role
            if (!$isAdmin) {
                $data['designation'] = null;
                $canChangePayment = false;
            }

            $user = User::create([...$data, 'password' => Hash::make($data['password'])]);

            // Save Admin Payment Permission if Admin role
            if ($isAdmin && $canChangePayment !== null) {
                AdminPaymentPermission::updateOrCreate(
                    ['admin_user_id' => $user->id],
                    [
                        'assigned_by' => auth()->id() ?? 1,
                        'can_change_payment' => (bool) $canChangePayment,
                    ]
                );
            }

            // Every user (Admin, Accountant, Member) receives an ID
            $profileData = $profile ?? [];
            if (empty($profileData['member_no'])) {
                $profileData['member_no'] = MemberProfile::generateMemberId();
            }
            $user->memberProfile()->create($profileData);

            // If the user is a Member, automatically assign any ongoing monthly subscription demands
            if ($role && $role->name === 'member') {
                $existingMonthlyDemands = \App\Models\Transaction::where('payment_category', 'monthly_payment')
                    ->whereNotNull('month')
                    ->select('month', 'amount', 'transaction_date', 'description')
                    ->groupBy('month', 'amount', 'transaction_date', 'description')
                    ->get();

                foreach ($existingMonthlyDemands as $demand) {
                    \App\Models\Transaction::create([
                        'member_id'        => $user->id,
                        'created_by'       => auth()->id() ?? 1,
                        'transaction_no'   => \App\Models\Transaction::generateTransactionNo(),
                        'type'             => 'payment',
                        'payment_category' => 'monthly_payment',
                        'amount'           => $demand->amount,
                        'status'           => 'pending',
                        'month'            => $demand->month,
                        'transaction_date' => $demand->transaction_date,
                        'description'      => $demand->description ?: "Monthly subscription for {$demand->month}",
                    ]);
                }
            }

            $this->logs->log('create', $user, null, $user->toArray());
            $this->notifications->send($user->id, 'Welcome', 'Your account has been created.', 'account');

            return $user->load('role', 'memberProfile', 'adminPaymentPermission');
        });
    }

    public function update(User $user, array $data): User
    {
        $roleId = $data['role_id'] ?? $user->role_id;
        $role = Role::find($roleId);

        // Prevent assigning super_admin to non-super_admin users
        if ($role && $role->name === 'super_admin' && !$user->isSuperAdmin()) {
            throw ValidationException::withMessages([
                'role_id' => 'Cannot promote user to Super Admin.',
            ]);
        }

        return DB::transaction(function () use ($user, $data, $role) {
            $old = $user->toArray();
            $profile = Arr::pull($data, 'profile');
            $canChangePayment = Arr::pull($data, 'can_change_payment');
            $isAdmin = $role && in_array($role->name, ['super_admin', 'admin']);

            // Designation and price modifications are strictly for Admin
            if (!$isAdmin) {
                $data['designation'] = null;
                $canChangePayment = false;
            }

            if (!empty($data['password'])) {
                $data['password'] = Hash::make($data['password']);
            } else {
                unset($data['password']);
            }

            $user->update($data);

            // Update Admin Payment Permission
            if ($isAdmin && $canChangePayment !== null && $role->name === 'admin') {
                AdminPaymentPermission::updateOrCreate(
                    ['admin_user_id' => $user->id],
                    [
                        'assigned_by' => auth()->id() ?? 1,
                        'can_change_payment' => (bool) $canChangePayment,
                    ]
                );
            } elseif (!$isAdmin || ($role && $role->name !== 'admin')) {
                AdminPaymentPermission::where('admin_user_id', $user->id)->delete();
            }

            // Ensure profile with ID exists
            if ($profile) {
                if ($user->memberProfile) {
                    $user->memberProfile->update($profile);
                } else {
                    if (empty($profile['member_no'])) {
                        $profile['member_no'] = MemberProfile::generateMemberId();
                    }
                    $user->memberProfile()->create($profile);
                }
            } elseif (!$user->memberProfile) {
                $user->memberProfile()->create([
                    'member_no' => MemberProfile::generateMemberId(),
                ]);
            }

            $this->logs->log('update', $user, $old, $user->fresh()->toArray());

            return $user->fresh(['role', 'memberProfile', 'adminPaymentPermission']);
        });
    }

    public function delete(User $user): void
    {
        if ($user->isSuperAdmin() || $user->email === 'superadmin@alamanah.com') {
            throw ValidationException::withMessages([
                'user' => 'The Super Admin root account cannot be deleted.',
            ]);
        }

        $this->logs->log('delete', $user, $user->toArray(), null);
        $user->delete(); // soft delete
    }

    public function assignRole(User $user, array $data): User
    {
        $role = Role::find($data['role_id'] ?? null);
        if ($role && $role->name === 'super_admin' && !$user->isSuperAdmin()) {
            throw ValidationException::withMessages([
                'role_id' => 'Cannot promote user to Super Admin.',
            ]);
        }

        $old = $user->only(['role_id', 'designation']);
        $isAdmin = $role && in_array($role->name, ['super_admin', 'admin']);

        if (!$isAdmin) {
            $data['designation'] = null;
        }

        $user->update($data);
        $this->logs->log('assign-role', $user, $old, $user->only(['role_id', 'designation']));

        return $user->load('role');
    }
}
