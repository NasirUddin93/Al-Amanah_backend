<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Receipt extends Model
{
    use SoftDeletes;

    public $timestamps = false;
    protected $fillable = ['transaction_id', 'member_id', 'created_by', 'receipt_no', 'amount', 'payment_method', 'receipt_date'];
    protected $casts    = ['amount' => 'decimal:2', 'receipt_date' => 'date', 'created_at' => 'datetime'];

    public function transaction() { return $this->belongsTo(Transaction::class); }
    public function member()      { return $this->belongsTo(User::class, 'member_id'); }
    public function creator()     { return $this->belongsTo(User::class, 'created_by'); }

    public static function generateReceiptNo(): string
    {
        return 'RCT-' . now()->format('Ymd') . '-' . str_pad((string) (static::withTrashed()->count() + 1), 5, '0', STR_PAD_LEFT);
    }
}
