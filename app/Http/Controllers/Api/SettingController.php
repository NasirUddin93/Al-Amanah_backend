<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\UpdateSettingRequest;
use App\Http\Resources\SettingResource;
use App\Models\Setting;
use App\Services\SettingService;
use Illuminate\Http\Request;

class SettingController extends Controller
{
    public function __construct(protected SettingService $service) {}

    public function index()
    {
        return SettingResource::collection(Setting::orderBy('setting_key')->get());
    }

    public function update(UpdateSettingRequest $request)
    {
        return new SettingResource(
            $this->service->updatePaymentValue(
                $request->user(),
                $request->setting_key,
                $request->setting_value
            )
        );
    }
}
