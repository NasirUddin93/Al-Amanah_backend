<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Fdr extends Model
{
    use SoftDeletes;

    public $timestamps = false;
    protected $table    = 'fdrs';
    protected $fillable = ['member_id', 'created_by', 'fdr_no', 'amount', 'start_date', 'maturity_date', 'status'];
    protected $casts    = ['amount' => 'decimal:2', 'start_date' => 'date', 'maturity_date' => 'date', 'created_at' => 'datetime'];

    public function member()  { return $this->belongsTo(User::class, 'member_id'); }
    public function creator() { return $this->belongsTo(User::class, 'created_by'); }
}
