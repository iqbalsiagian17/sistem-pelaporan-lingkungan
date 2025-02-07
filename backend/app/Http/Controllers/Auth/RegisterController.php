<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class RegisterController extends Controller
{
    /**
     * Constructor: Hanya guest yang bisa register
     */
    public function __construct()
    {
        $this->middleware('guest');
    }

    /**
     * API Register User
     */
    public function register(Request $request)
    {
        // Validasi input user
        $validator = Validator::make($request->all(), [
            'username' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:t_user',
            'password' => 'required|string|min:8|confirmed',
        ]);

        // Jika validasi gagal, kembalikan respon error
        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        // Buat user baru
        $user = User::create([
            'username' => $request->username,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'type' => 0, // Otomatis jadi Admin (type 0)
        ]);

        // Buat token autentikasi
        $token = $user->createToken('auth_token')->plainTextToken;

        // Respon sukses dengan token
        return response()->json([
            'message' => 'User registered successfully!',
            'user' => [
                'id' => $user->id,
                'username' => $user->username,
                'email' => $user->email,
                'role' => 'User',
            ],
            'token' => $token,
        ], 201);
    }
}
