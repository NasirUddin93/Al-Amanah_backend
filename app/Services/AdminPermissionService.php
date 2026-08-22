<?php

namespace App\Services;

use App\Models\AdminPaymentPermission;

class AdminPermissionService
{
    public function __construct(
        protected ActivityLogService $logs,
        protected NotificationService $notifications,
    ) {}

    public function list()
    {
        return AdminPaymentPermission::with(['admin.role', 'assignedBy'])->latest()->paginate(15);
    }

    public function assign(array $data): AdminPaymentPermission
    {
        $permission = AdminPaymentPermission::updateOrCreate(
            ['admin_user_id' => $data['admin_user_id']],
            ['assigned_by' => auth()->id(), 'can_change_payment' => $data['can_change_payment']]
        );

        $this->logs->log('update', $permission);
        $this->notifications->send(
            $permission->admin_user_id,
            'Payment Permission',
            $permission->can_change_payment ? 'You can now change payment values.' : 'Your payment value permission was removed.',
            'permission'
        );

        return $permission->load('admin');
    }
}
