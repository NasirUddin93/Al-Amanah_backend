<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Transaction extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'member_id',
        'created_by',
        'updated_by',
        'transaction_no',
        'type',
        'payment_category',
        'amount',
        'status',
        'month',
        'transaction_date',
        'description',
        'receipt_photo',
        'receipt_photo_uploaded_at',
        'receipt_photo_uploaded_by',
        'member_paid_amount',
        'member_trx_reference',
        'member_payment_method',
        'member_comment',
        'rejection_reason',
    ];

    protected $casts = [
        'amount'             => 'decimal:2',
        'member_paid_amount' => 'decimal:2',
        'transaction_date'   => 'date',
    ];

    public function member()  { return $this->belongsTo(User::class, 'member_id'); }
    public function creator() { return $this->belongsTo(User::class, 'created_by'); }
    public function updater() { return $this->belongsTo(User::class, 'updated_by'); }
    public function receipt() { return $this->hasOne(Receipt::class); }

    public static function generateTransactionNo(): string
    {
        return 'TRX-' . now()->format('Ymd') . '-' . str_pad((string) (static::withTrashed()->count() + 1), 5, '0', STR_PAD_LEFT);
    }
}
