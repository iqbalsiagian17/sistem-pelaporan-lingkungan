<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Http;

class Report extends Model
{
    use HasFactory;

    protected $table = 't_report';

    protected $fillable = [
        'user_id',
        'report_number',
        'title',
        'description',
        'date',
        'district',
        'village',
        'location_details',
        'latitude',
        'longitude',
        'likes',
        'status'
    ];


    protected $casts = [
        'date' => 'date',
        'latitude' => 'decimal:8',
        'longitude' => 'decimal:8',
    ];

    // Auto-generate report number saat membuat laporan baru
    protected static function boot()
    {
        parent::boot();

        static::creating(function ($report) {
            // Generate nomor laporan otomatis
            $lastReport = self::orderBy('id', 'desc')->first();
            $nextNumber = $lastReport ? str_pad($lastReport->id + 1, 5, '0', STR_PAD_LEFT) : '00001';
            $report->report_number = $nextNumber;
        });
    }

    // Relasi ke User (Pelapor)
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function attachments()
    {
        return $this->hasMany(ReportAttachment::class, 'report_id');
    }

    public function followUps()
    {
        return $this->hasMany(ReportFollowUp::class, 'report_id');
    }
}
