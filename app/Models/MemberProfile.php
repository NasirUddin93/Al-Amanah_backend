<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class MemberProfile extends Model
{
    use SoftDeletes;

    public $timestamps = false;
    protected $table = 'user_profiles';
    protected $fillable = ['user_id', 'member_no', 'phone', 'address', 'share_amount'];
    protected $casts    = ['share_amount' => 'decimal:2', 'created_at' => 'datetime'];

    public function user() { return $this->belongsTo(User::class); }

    public static function generateMemberId(): string
    {
        $lastId = static::withTrashed()->max('id') ?? 0;
        $next = $lastId + 1;
        $candidate = sprintf('AMN-%04d', $next);

        while (static::withTrashed()->where('member_no', $candidate)->exists()) {
            $next++;
            $candidate = sprintf('AMN-%04d', $next);
        }

        return $candidate;
    }
}
