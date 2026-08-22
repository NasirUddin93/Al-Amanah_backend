<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Role extends Model
{
    use SoftDeletes;

    public $timestamps = false;
    protected $fillable = ['name', 'description'];

    public function permissions() { return $this->belongsToMany(Permission::class, 'role_permissions'); }
    public function users()       { return $this->hasMany(User::class); }
}
