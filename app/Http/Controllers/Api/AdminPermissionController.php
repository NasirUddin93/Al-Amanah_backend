<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\AssignPaymentPermissionRequest;
use App\Http\Resources\AdminPaymentPermissionResource;
use App\Services\AdminPermissionService;

class AdminPermissionController extends Controller
{
    public function __construct(protected AdminPermissionService $service) {}

    public function index()
    {
        return AdminPaymentPermissionResource::collection($this->service->list());
    }

    public function store(AssignPaymentPermissionRequest $request)
    {
        return new AdminPaymentPermissionResource($this->service->assign($request->validated()));
    }

    public function update(AssignPaymentPermissionRequest $request)
    {
        return new AdminPaymentPermissionResource($this->service->assign($request->validated()));
    }
}
