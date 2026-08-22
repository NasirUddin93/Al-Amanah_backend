<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Permission;
use App\Models\Role;
use App\Services\ActivityLogService;
use Illuminate\Http\Request;

class RoleController extends Controller
{
    public function index()
    {
        return response()->json(
            Role::with('permissions')
                ->withCount('users')
                ->whereNull('deleted_at')
                ->get()
        );
    }

    public function permissions()
    {
        return response()->json(
            Permission::all()
        );
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name' => 'required|string|max:50|unique:roles,name',
            'description' => 'nullable|string|max:255',
            'permissions' => 'nullable|array',
            'permissions.*' => 'integer|exists:permissions,id',
        ]);

        $role = Role::create([
            'name' => strtolower(trim(str_replace(' ', '_', $data['name']))),
            'description' => $data['description'] ?? null,
        ]);

        if (!empty($data['permissions'])) {
            $role->permissions()->sync($data['permissions']);
        }

        ActivityLogService::log('create', 'roles', $role->id, "Created role {$role->name}");

        return response()->json(
            $role->load('permissions')->loadCount('users'),
            201
        );
    }

    public function show(Role $role)
    {
        return response()->json(
            $role->load('permissions')->loadCount('users')
        );
    }

    public function update(Request $request, Role $role)
    {
        $data = $request->validate([
            'name' => 'sometimes|required|string|max:50|unique:roles,name,' . $role->id,
            'description' => 'nullable|string|max:255',
            'permissions' => 'nullable|array',
            'permissions.*' => 'integer|exists:permissions,id',
        ]);

        if (isset($data['name']) && !in_array($role->name, ['super_admin', 'admin', 'member'])) {
            $role->name = strtolower(trim(str_replace(' ', '_', $data['name'])));
        }

        if (array_key_exists('description', $data)) {
            $role->description = $data['description'];
        }

        $role->save();

        if (isset($data['permissions'])) {
            $role->permissions()->sync($data['permissions']);
        }

        ActivityLogService::log('update', 'roles', $role->id, "Updated role {$role->name}");

        return response()->json(
            $role->load('permissions')->loadCount('users')
        );
    }

    public function destroy(Role $role)
    {
        if (in_array($role->name, ['super_admin', 'admin', 'member'])) {
            return response()->json([
                'message' => 'System default roles cannot be deleted.'
            ], 422);
        }

        if ($role->users()->exists()) {
            return response()->json([
                'message' => 'Cannot delete role because active users are currently assigned to it.'
            ], 422);
        }

        $role->delete();

        ActivityLogService::log('delete', 'roles', $role->id, "Deleted role {$role->name}");

        return response()->json([
            'message' => 'Role deleted successfully.'
        ]);
    }
}
