<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use App\Http\Resources\UserCollection;
use App\Http\Resources\UserResource;
use App\Models\User;
use App\Services\UserService;
use Illuminate\Http\Request;

class UserController extends Controller
{
    public function __construct(protected UserService $service) {}

    public function index()
    {
        return new UserCollection($this->service->list());
    }

    public function store(StoreUserRequest $request)
    {
        return new UserResource($this->service->create($request->validated()));
    }

    public function show(User $user)
    {
        return new UserResource($user->load('role', 'memberProfile'));
    }

    public function update(UpdateUserRequest $request, User $user)
    {
        return new UserResource($this->service->update($user, $request->validated()));
    }

    public function destroy(User $user)
    {
        $this->service->delete($user);

        return response()->json(['message' => 'User deleted (soft).']);
    }

    public function assignRole(Request $request, User $user)
    {
        $data = $request->validate([
            'role_id'     => ['required', 'exists:roles,id'],
            'designation' => ['nullable', 'string', 'max:100'],
        ]);

        return new UserResource($this->service->assignRole($user, $data));
    }
}
