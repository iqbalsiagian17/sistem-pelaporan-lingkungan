<?php

return [
    'defaults' => [
        'guard' => 'api', // ⬅️ PASTIKAN default guard adalah 'api'
        'passwords' => 'users',
    ],

    'guards' => [
        'api' => [
            'driver' => 'jwt', // ⬅️ PASTIKAN driver adalah 'jwt'
            'provider' => 'users',
        ],
    ],

    'providers' => [
        'users' => [
            'driver' => 'eloquent',
            'model' => App\Models\User::class,
        ],
    ],
];
