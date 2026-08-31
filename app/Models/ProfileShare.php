<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProfileShare extends Model
{
    public $timestamps = false;
    protected $fillable = ['primary_user_id', 'shared_user_id', 'relation', 'group_name', 'status'];
    protected $casts    = ['created_at' => 'datetime'];

    public function primaryUser() { return $this->belongsTo(User::class, 'primary_user_id'); }
    public function sharedUser()  { return $this->belongsTo(User::class, 'shared_user_id'); }
}
