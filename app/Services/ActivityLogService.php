<?php

namespace App\Services;

use App\Models\ActivityLog;
use Illuminate\Database\Eloquent\Model;

class ActivityLogService
{
    public function log(string $action, Model $model, ?array $old = null, ?array $new = null): void
    {
        ActivityLog::create([
            'user_id'    => auth()->id(),
            'action'     => $action,
            'table_name' => $model->getTable(),
            'record_id'  => $model->getKey(),
            'old_values' => $old,
            'new_values' => $new,
            'ip_address' => request()->ip(),
        ]);
    }
}
