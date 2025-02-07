<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserInfo extends Model
{
    use HasFactory;

    protected $table = 't_user_info';

    protected $fillable = [
        'user_id',
        'full_name',
        'address',
        'phone_number',
        'birth_date',
        'gender',
        'profile_picture',
        'job',
    ];

    protected $casts = [
        'birth_date' => 'date',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'id');
    }
}
