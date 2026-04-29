<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureVerifiedBusiness
{
    public function handle(Request $request, Closure $next): Response
    {
        if (!$request->user() || !$request->user()->isVerifiedBusiness()) {
            return response()->json([
                'message' => 'Access denied. Only verified businesses can access medicines.',
            ], Response::HTTP_FORBIDDEN);
        }

        return $next($request);
    }
}
