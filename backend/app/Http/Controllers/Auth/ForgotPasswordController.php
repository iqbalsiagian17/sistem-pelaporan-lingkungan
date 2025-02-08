<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Notifications\ResetPasswordNotification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Password;
use Tymon\JWTAuth\Facades\JWTAuth;

class ForgotPasswordController extends Controller
{
    public function sendResetLinkEmail(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:t_user,email'
        ]);

        // Cari user berdasarkan email
        $user = User::where('email', $request->email)->first();

        // **Set waktu expired token (15 menit)**
        JWTAuth::factory()->setTTL(15);

        // **Buat token JWT khusus reset password**
        $customClaims = ['reset_password' => true]; // Klaim khusus untuk reset password
        $token = JWTAuth::claims($customClaims)->fromUser($user);
        
        // **Buat URL reset password**
        $resetUrl = rtrim(env('FRONTEND_URL'), '/') . "/reset-password?token=" . urlencode($token);

        // **Kirim email ke user**
        $user->notify(new ResetPasswordNotification($resetUrl));

        return response()->json([
            'status' => 'success',
            'message' => 'Reset password link sent to your email!',
            'reset_url' => $resetUrl // Untuk testing di Postman
        ], 200);
    }
}