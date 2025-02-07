<?php

namespace App\Http\Controllers\Admin\Dashboard;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class AdminDashboardController extends Controller
{
    public function dashboard(Request $request)
    {
        // Ambil user yang sedang login
        $admin = $request->user();

        // Pastikan user adalah admin (type = 0)
        if ($admin->type !== 0) {
            return response()->json([
                'message' => 'Forbidden: You do not have access to this page'
            ], 403);
        }

        // Data dashboard
        return response()->json([
            'message' => 'Welcome to the Admin Dashboard',
            'admin' => [
                'id' => $admin->id,
                'username' => $admin->username,
                'email' => $admin->email,
                'role' => 'Admin',
            ],
        ], 200);
    }
}
