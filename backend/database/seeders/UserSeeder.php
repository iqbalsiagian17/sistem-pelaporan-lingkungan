<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // Buat user dengan role 'user'
        User::create([
            'username' => 'user@gmail.com',
            'email' => 'user@gmail.com',
            'password' => Hash::make('password'), // Hashing the password
            'type' => 0, // 0 for 'user'
        ]);

        // Buat user dengan role 'admin'
        User::create([
            'username' => 'admin@gmail.com',
            'email' => 'admin@gmail.com',
            'password' => Hash::make('password'), // Hashing the password
            'type' => 1, // 1 for 'admin'
        ]);
    }
}
