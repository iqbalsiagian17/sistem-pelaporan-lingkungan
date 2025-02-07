<?php

namespace App\Http\Controllers\User\Profile;

use App\Http\Controllers\Controller;
use App\Models\UserInfo;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class UserProfileController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    public function showProfile(Request $request)
    {
        $user = $request->user();

        // Cek apakah user memiliki informasi profil
        $userInfo = UserInfo::where('user_id', $user->id)->first();

        if (!$userInfo) {
            return response()->json(['message' => 'User info not found'], 404);
        }

        return response()->json([
            'message' => 'User info retrieved successfully',
            'user' => [
                'id' => $user->id,
                'email' => $user->email,
                'role' => $user->type == "user" ? "user" : "admin",
                'profile' => $userInfo,
            ]
        ], 200);
    }

    public function storeProfile(Request $request)
    {
        $user = $request->user();

        if (UserInfo::where('user_id', $user->id)->exists()) {
            return response()->json(['message' => 'User info already exists'], 400);
        }

        $validator = Validator::make($request->all(), [
            'full_name' => 'required|string|max:255',
            'address' => 'required|string|max:500',
            'phone_number' => 'required|string|max:20',
            'birth_date' => 'required|date',
            'gender' => 'required|string|in:male,female',
            'profile_picture' => 'nullable|image|mimes:jpg,png,jpeg|max:2048', 
            'job' => 'nullable|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        if ($request->hasFile('profile_picture')) {
            $image = $request->file('profile_picture');
            $imageName = time() . '_' . $user->id . '.' . $image->getClientOriginalExtension();
            $image->move(public_path('profile_pictures'), $imageName);
            $profilePicturePath = 'profile_pictures/' . $imageName;
        } else {
            $profilePicturePath = null;
        }

        $userInfo = UserInfo::create([
            'user_id' => $user->id,
            'full_name' => $request->full_name,
            'address' => $request->address,
            'phone_number' => $request->phone_number,
            'birth_date' => $request->birth_date,
            'gender' => $request->gender,
            'profile_picture' => $profilePicturePath,
            'job' => $request->job,
        ]);

        return response()->json([
            'message' => 'User info added successfully',
            'profile' => $userInfo
        ], 201);
    }


    public function updateProfile(Request $request)
    {
        $user = $request->user();

        $userInfo = UserInfo::where('user_id', $user->id)->first();

        if (!$userInfo) {
            return response()->json(['message' => 'User info not found'], 404);
        }

        $validator = Validator::make($request->all(), [
            'full_name' => 'sometimes|string|max:255',
            'address' => 'sometimes|string|max:500',
            'phone_number' => 'sometimes|string|max:20',
            'birth_date' => 'sometimes|date',
            'gender' => 'sometimes|string|in:male,female',
            'profile_picture' => 'nullable|image|mimes:jpg,png,jpeg|max:2048', 
            'job' => 'nullable|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        if ($request->hasFile('profile_picture')) {
            if ($userInfo->profile_picture && file_exists(public_path($userInfo->profile_picture))) {
                unlink(public_path($userInfo->profile_picture));
            }

            $image = $request->file('profile_picture');
            $imageName = time() . '_' . $user->id . '.' . $image->getClientOriginalExtension();
            $image->move(public_path('profile_pictures'), $imageName);
            $profilePicturePath = 'profile_pictures/' . $imageName;

            $userInfo->profile_picture = $profilePicturePath;
        }

        $userInfo->update($request->only([
            'full_name', 'address', 'phone_number', 'birth_date', 'gender', 'job'
        ]));

        return response()->json([
            'message' => 'User info updated successfully',
            'profile' => $userInfo
        ], 200);
    }

    public function changePassword(Request $request)
    {
        $request->validate([
            'current_password' => 'required|string|min:8',
            'new_password' => 'required|string|min:8|confirmed'
        ]);

        $user = $request->user();

        // Cek apakah password lama sesuai
        if (!Hash::check($request->current_password, $user->password)) {
            return response()->json(['message' => 'Password lama salah'], 400);
        }

        // Update password
        $user->password = Hash::make($request->new_password);
        $user->save();

        return response()->json(['message' => 'Password berhasil diperbarui'], 200);
    }


}
