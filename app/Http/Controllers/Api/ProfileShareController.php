<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreProfileShareRequest;
use App\Http\Resources\ProfileShareResource;
use App\Models\ProfileShare;
use App\Services\ProfileShareService;
use Illuminate\Http\Request;

class ProfileShareController extends Controller
{
    public function __construct(protected ProfileShareService $service) {}

    public function index(Request $request)
    {
        return ProfileShareResource::collection($this->service->list($request->user()));
    }

    public function store(StoreProfileShareRequest $request)
    {
        return new ProfileShareResource($this->service->create($request->validated()));
    }

    public function update(Request $request, ProfileShare $profileShare)
    {
        $data = $request->validate([
            'status'     => ['nullable', 'in:active,inactive'],
            'group_name' => ['nullable', 'string', 'max:100'],
        ]);

        return new ProfileShareResource($this->service->update($profileShare, $data));
    }

    public function destroy(ProfileShare $profileShare)
    {
        $this->service->delete($profileShare);

        return response()->json(['message' => 'Linked profile removed successfully.']);
    }
}
