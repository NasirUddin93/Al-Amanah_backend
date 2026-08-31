<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, SoftDeletes;

    protected $fillable = ['role_id', 'name', 'email', 'password', 'designation', 'is_active'];
    protected $hidden   = ['password'];
    protected $casts    = ['is_active' => 'boolean', 'deleted_at' => 'datetime'];

    public function role()                   { return $this->belongsTo(Role::class); }
    public function memberProfile()          { return $this->hasOne(MemberProfile::class); }
    public function adminPaymentPermission() { return $this->hasOne(AdminPaymentPermission::class, 'admin_user_id'); }
    public function profileSharesPrimary()   { return $this->hasMany(ProfileShare::class, 'primary_user_id'); }
    public function profileSharesShared()    { return $this->hasMany(ProfileShare::class, 'shared_user_id'); }
    public function transactions()           { return $this->hasMany(Transaction::class, 'member_id'); }
    public function receipts()               { return $this->hasMany(Receipt::class, 'member_id'); }
    public function fdrs()                   { return $this->hasMany(Fdr::class, 'member_id'); }
    public function notifications()          { return $this->hasMany(Notification::class); }
    public function activityLogs()           { return $this->hasMany(ActivityLog::class); }

    public function hasRole(string $role): bool  { return $this->role?->name === $role; }
    public function hasAnyRole(array|string ...$roles): bool
    {
        $roleList = is_array($roles[0] ?? null) ? $roles[0] : $roles;
        return in_array($this->role?->name, (array) $roleList, true);
    }
    public function isSuperAdmin(): bool         { return $this->hasRole('super_admin'); }
    public function isAdmin(): bool              { return $this->hasRole('admin'); }
    public function isAccountant(): bool         { return $this->hasRole('accountant'); }
    public function isMember(): bool             { return $this->hasRole('member'); }

    public function canChangePayment(): bool
    {
        if ($this->isSuperAdmin()) return true;
        return (bool) ($this->adminPaymentPermission?->can_change_payment
            ?? AdminPaymentPermission::where('admin_user_id', $this->id)->value('can_change_payment'));
    }
}
