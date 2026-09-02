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
        $items = is_array($decoded) ? array_values(array_filter($decoded)) : [$raw];
        return array_values(array_filter(array_map(fn($p) => $this->normalizePhotoUrl($p), $items)));
    }

    public function getIdPhotoAttribute($value): ?string
    {
        if (empty($value)) {
            return null;
        }
        $decoded = json_decode($value, true);
        if (is_array($decoded)) {
            return $this->normalizePhotoUrl($decoded[0] ?? null);
        }
        return $this->normalizePhotoUrl($value);
    }

    protected function normalizePhotoUrl(?string $item): ?string
    {
        if (empty($item)) {
            return null;
        }
        if (str_contains($item, 'storage/id_photos/')) {
            $filename = basename(parse_url($item, PHP_URL_PATH));
            return url('api/id-photos/' . $filename);
        }
        return $item;
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
