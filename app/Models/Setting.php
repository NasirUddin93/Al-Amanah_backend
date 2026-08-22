<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Setting extends Model
{
    public $timestamps = false;
    protected $fillable = ['updated_by', 'setting_key', 'setting_value', 'description'];

    public function updatedBy() { return $this->belongsTo(User::class, 'updated_by'); }
}
