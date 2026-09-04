<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\MemberProfile;
use App\Models\ProfileShare;
use App\Models\User;
use Illuminate\Http\Request;
use Laravel\Sanctum\PersonalAccessToken;

class IdPhotoController extends Controller
{
    /**
     * Securely stream member ID photo with authentication & authorization.
     */
    public function show(Request $request, string $filename)
    {
        // 1. Authenticate user from Sanctum Bearer header or token query parameter
        $user = $request->user('sanctum');

        if (!$user) {
            $rawToken = $request->bearerToken() ?: $request->query('token');
            if ($rawToken) {
                $accessToken = PersonalAccessToken::findToken($rawToken);
                if ($accessToken && (!$accessToken->expires_at || $accessToken->expires_at->isFuture())) {
                    $user = $accessToken->tokenable;
                }
            }
        }

        if (!$user) {
            return response()->json(['message' => 'Unauthenticated.'], 401);
        }

        // 2. Prevent path traversal
        $cleanFilename = basename($filename);

        // Check primary private location backend/storage/id_photos
        $filePath = storage_path('id_photos/' . $cleanFilename);

        // Fallback check in case file is still in app/public during migration
        if (!file_exists($filePath)) {
            $fallback = storage_path('app/public/id_photos/' . $cleanFilename);
            if (file_exists($fallback)) {
                $filePath = $fallback;
            } else {
                return response()->json(['message' => 'Document not found.'], 404);
            }
        }

        // 3. Authorization Check
        // Super Admins, Admins, and Accountants have full management access
        $isStaff = $user->isSuperAdmin() || $user->hasAnyRole(['admin', 'super_admin', 'accountant']);

        if (!$isStaff) {
            // Find who this photo belongs to
            $profile = MemberProfile::where('id_photo', 'like', '%' . $cleanFilename . '%')->first();

            $isAllowed = false;
            if ($profile) {
                // If it is the user's own profile
                if ($profile->user_id === $user->id) {
                    $isAllowed = true;
                } else {
                    // Check if the user is in an active merged group with the photo owner
                    $isShared = ProfileShare::where('status', 'active')
                        ->where(function ($q) use ($user, $profile) {
                            $q->where(function ($sub) use ($user, $profile) {
                                $sub->where('primary_user_id', $user->id)
                                    ->where('shared_user_id', $profile->user_id);
                            })->orWhere(function ($sub) use ($user, $profile) {
                                $sub->where('primary_user_id', $profile->user_id)
                                    ->where('shared_user_id', $user->id);
                            });
                        })
                        ->exists();

                    if ($isShared) {
                        $isAllowed = true;
                    }
                }
            }

            if (!$isAllowed) {
                return response()->json([
                    'message' => 'Unauthorized. You do not have permission to view this document.'
                ], 403);
            }
        }

        // 4. Return the file with proper headers
        $mime = mime_content_type($filePath) ?: 'image/png';

        return response()->file($filePath, [
            'Content-Type'                => $mime,
            'Cache-Control'               => 'private, max-age=86400',
            'Access-Control-Allow-Origin' => '*',
            'Content-Disposition'         => 'inline; filename="' . $cleanFilename . '"',
        ]);
    }
}
