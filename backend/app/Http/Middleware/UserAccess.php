<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class UserAccess
{
    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next, $userType)
    {
        // Pastikan user sudah login
        if (!auth()->check()) {
            return response()->json(['message' => 'Unauthorized: Please log in first'], 401);
        }

        // Cek apakah type user sesuai dengan yang diizinkan
        if (auth()->user()->type != $userType) {
            return response()->json([
                'message' => 'Forbidden: You do not have permission to access this page'
            ], 403);
        }

        return $next($request);
    }
}
