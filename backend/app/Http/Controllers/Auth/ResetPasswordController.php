<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Password;
use Tymon\JWTAuth\Facades\JWTAuth;
use App\Models\User;

class ResetPasswordController extends Controller
{
    public function reset(Request $request)
    {
        $request->validate([
            'token' => 'required|string',
            'password' => 'required|string|min:8|confirmed',
        ]);

        try {
            // Decode JWT token
            $payload = JWTAuth::setToken($request->token)->getPayload();

            // Pastikan ini adalah token reset password, bukan token login
            if (!$payload->hasKey('reset_password') || !$payload->get('reset_password')) {
                return response()->json(['status' => 'error', 'message' => 'Invalid token type!'], 400);
            }

            // Cari user berdasarkan ID di token
            $user = User::findOrFail($payload->get('sub'));

            // Update password user
            $user->update(['password' => Hash::make($request->password)]);

            // Hapus semua token JWT agar user harus login ulang
            JWTAuth::invalidate($request->token);

            return response()->json(['status' => 'success', 'message' => 'Password successfully reset!'], 200);

        } catch (\Exception $e) {
            return response()->json(['status' => 'error', 'message' => 'Invalid or expired token!'], 400);
        }
    }

}
