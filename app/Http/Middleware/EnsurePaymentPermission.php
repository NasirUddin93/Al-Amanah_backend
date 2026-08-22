<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsurePaymentPermission
{
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        abort_unless(
            $user && ($user->isSuperAdmin() || $user->canChangePayment()),
            403,
            'Not allowed to change payment values.'
        );

        return $next($request);
    }
}
