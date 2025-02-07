<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class RoleMiddleware
{
    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next, ...$roles): mixed
    {
        // Ambil user yang sedang login
        $user = $request->user();

        if (!$user) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        // Cek apakah user memiliki salah satu role yang diizinkan
        if (!in_array($user->type, $roles)) {
            return response()->json(['message' => 'Forbidden: You do not have access'], 403);
        }

        return $next($request);
    }
}
