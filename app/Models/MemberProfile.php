<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class MemberProfile extends Model
{
    use SoftDeletes;

    public $timestamps = false;
    protected $table = 'user_profiles';
    protected $fillable = ['user_id', 'member_no', 'phone', 'address', 'id_photo', 'share_amount'];
    protected $casts    = ['share_amount' => 'decimal:2', 'created_at' => 'datetime'];
    protected $appends  = ['id_photos'];

    public function user() { return $this->belongsTo(User::class); }

    public function getIdPhotosAttribute(): array
    {
        if (empty($this->attributes['id_photo'])) {
            return [];
        }
        $raw = $this->attributes['id_photo'];
        $decoded = json_decode($raw, true);
        if (is_array($decoded)) {
            return array_values(array_filter($decoded));
        }
        return [$raw];
    }

    public function getIdPhotoAttribute($value): ?string
    {
        if (empty($value)) {
            return null;
        }
        $decoded = json_decode($value, true);
        if (is_array($decoded)) {
            return $decoded[0] ?? null;
        }
        return $value;
    }

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
