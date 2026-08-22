<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Permission extends Model
{
    public $timestamps = false;
    protected $fillable = ['module', 'action', 'description'];

    public function roles() { return $this->belongsToMany(Role::class, 'role_permissions'); }
}
