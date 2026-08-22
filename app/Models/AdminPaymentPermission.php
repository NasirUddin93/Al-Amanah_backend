<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AdminPaymentPermission extends Model
{
    public $timestamps = false;
    protected $fillable = ['admin_user_id', 'assigned_by', 'can_change_payment'];
    protected $casts    = ['can_change_payment' => 'boolean', 'created_at' => 'datetime'];

    public function admin()     { return $this->belongsTo(User::class, 'admin_user_id'); }
    public function assignedBy(){ return $this->belongsTo(User::class, 'assigned_by'); }
}
