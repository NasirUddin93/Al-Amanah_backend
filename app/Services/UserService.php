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
        protected MediaService $media,
        protected ImageProcessor $imageProcessor,
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
            if (array_key_exists('id_photos', $profileData) || array_key_exists('id_photo', $profileData)) {
                $rawPhotos = $profileData['id_photos'] ?? $profileData['id_photo'] ?? null;
                $profileData['id_photo'] = $this->processIdPhotos($rawPhotos);
                unset($profileData['id_photos']);
            }
            if (empty($profileData['member_no'])) {
                $profileData['member_no'] = MemberProfile::generateMemberId();
            }
            $user->memberProfile()->create($profileData);

            // If the user is a Member, automatically assign any ongoing monthly subscription demands
            if ($role && $role->name === 'member') {
                $distinctMonths = \App\Models\Transaction::where('payment_category', 'monthly_payment')
                    ->whereNotNull('month')
                    ->distinct()
                    ->pluck('month');

                foreach ($distinctMonths as $monthName) {
                    $firstTrx = \App\Models\Transaction::where('payment_category', 'monthly_payment')
                        ->where('month', $monthName)
                        ->where('description', 'not like', 'Remaining due%')
                        ->where('description', 'not like', '%Partial payment%')
                        ->orderBy('id', 'asc')
                        ->first();

                    $sampleMemberId = \App\Models\Transaction::where('payment_category', 'monthly_payment')
                        ->where('month', $monthName)
                        ->value('member_id');

                    $fullAmount = $sampleMemberId
                        ? \App\Models\Transaction::where('payment_category', 'monthly_payment')
                            ->where('month', $monthName)
                            ->where('member_id', $sampleMemberId)
                            ->whereIn('status', ['pending', 'paid'])
                            ->sum('amount')
                        : ($firstTrx ? $firstTrx->amount : 2000);

                    $cleanTrxNo = $firstTrx?->transaction_no
                        ?: \App\Models\Transaction::where('payment_category', 'monthly_payment')
                            ->where('month', $monthName)
                            ->whereNotNull('transaction_no')
                            ->value('transaction_no')
                        ?: \App\Models\Transaction::generateTransactionNo();

                    $dueDate = $firstTrx?->transaction_date
                        ?: \App\Models\Transaction::where('payment_category', 'monthly_payment')
                            ->where('month', $monthName)
                            ->value('transaction_date')
                        ?: now()->toDateString();

                    $cleanDesc = "Monthly subscription for {$monthName}";
                    if ($firstTrx && $firstTrx->description) {
                        $rawDesc = preg_replace('/\s*-\s*Ref:.*$/i', '', $firstTrx->description);
                        $rawDesc = preg_replace('/\s*\(Partial payment:.*$/i', '', $rawDesc);
                        if (trim($rawDesc)) {
                            $cleanDesc = trim($rawDesc);
                        }
                    }

                    \App\Models\Transaction::create([
                        'member_id'        => $user->id,
                        'created_by'       => auth()->id() ?? 1,
                        'transaction_no'   => $cleanTrxNo,
                        'type'             => 'payment',
                        'payment_category' => 'monthly_payment',
                        'amount'           => $fullAmount,
                        'status'           => 'pending',
                        'month'            => $monthName,
                        'transaction_date' => $dueDate,
                        'description'      => $cleanDesc,
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
                if (array_key_exists('id_photos', $profile) || array_key_exists('id_photo', $profile)) {
                    $rawStored = $user->memberProfile ? $user->memberProfile->getRawOriginal('id_photo') : null;
                    $previousPhotos = $this->storedIdPhotosToList($rawStored);

                    $rawPhotos = $profile['id_photos'] ?? $profile['id_photo'] ?? null;
                    $profile['id_photo'] = $this->processIdPhotos($rawPhotos);

                    $this->deleteRemovedIdPhotos($previousPhotos, $profile['id_photo']);

                    unset($profile['id_photos']);
                }
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

    /**
     * Convert the raw `user_profiles.id_photo` column value to a list of photo
     * references. Accepts JSON arrays, plain filenames, or legacy URL strings.
     */
    protected function storedIdPhotosToList(?string $stored): array
    {
        if (empty($stored)) {
            return [];
        }

        $decoded = json_decode($stored, true);
        $items = is_array($decoded) ? $decoded : [$stored];

        return array_values(array_filter(array_map(
            fn ($item) => (is_string($item) && trim($item) !== '') ? trim($item) : null,
            $items
        )));
    }

    protected function processIdPhotos(mixed $photoData): ?string
    {
        if (empty($photoData)) {
            return null;
        }

        $items = [];
        if (is_array($photoData)) {
            $items = $photoData;
        } elseif (is_string($photoData)) {
            $decoded = json_decode($photoData, true);
            if (is_array($decoded)) {
                $items = $decoded;
            } else {
                $items = [$photoData];
            }
        }

        $processed = [];
        foreach ($items as $item) {
            if (!is_string($item) || trim($item) === '') {
                continue;
            }

            // Base64 data URL -> store as a new private ID document.
            if ($this->media->isBase64DataUrl($item)) {
                try {
                    $decoded = $this->media->decodeBase64($item);
                } catch (\InvalidArgumentException $e) {
                    throw ValidationException::withMessages([
                        'profile.id_photos' => $e->getMessage(),
                    ]);
                }

                $fileName = $this->imageProcessor->processIdPhoto($decoded) ?? $this->media->storeIdPhoto($decoded, $this->media->extractExtension($item));
                if ($fileName === null || trim($fileName) === '') {
                    throw ValidationException::withMessages([
                        'profile.id_photos' => 'The uploaded photo could not be processed.',
                    ]);
                }
                $processed[] = $fileName;
                continue;
            }

            // Normalize existing legacy / full-URL values to relative disk filenames.
            $normalized = $this->media->normalizePath($item);
            if ($normalized === null || $normalized === '') {
                continue;
            }

            $processed[] = $normalized;
        }

        if (empty($processed)) {
            return null;
        }

        return json_encode(array_values($processed));
    }

    /**
     * Delete private ID photo files that were removed from a profile's list.
     *
     * @param  array  $previousPhotos  Filenames stored before the update.
     * @param  string|null  $newPhotosJson  JSON array of the remaining filenames.
     */
    protected function deleteRemovedIdPhotos(array $previousPhotos, ?string $newPhotosJson): void
    {
        if (!is_array($previousPhotos) || empty($previousPhotos)) {
            return;
        }

        $current = [];
        if (is_string($newPhotosJson)) {
            $decoded = json_decode($newPhotosJson, true);
            if (is_array($decoded)) {
                $current = $decoded;
            } else {
                $current = [$newPhotosJson];
            }
        }

        $currentNormalized = array_map(fn ($p) => $this->media->normalizePath($p), $current);

        foreach ($previousPhotos as $previous) {
            if (!is_string($previous) || trim($previous) === '') {
                continue;
            }

            $previousNormalized = $this->media->normalizePath($previous);
            if ($previousNormalized === null || in_array($previousNormalized, $currentNormalized, true)) {
                continue;
            }

            $this->media->delete($previousNormalized, 'id_photos');
        }
    }
}
