<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class MeetingExpense extends Model
{
    use SoftDeletes;

    public $timestamps = false;
    protected $fillable = ['created_by', 'title', 'expense_date', 'amount', 'description'];
    protected $casts    = ['amount' => 'decimal:2', 'expense_date' => 'date', 'created_at' => 'datetime'];

    public function creator() { return $this->belongsTo(User::class, 'created_by'); }
}
