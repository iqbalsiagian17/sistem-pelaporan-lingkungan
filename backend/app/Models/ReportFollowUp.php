<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ReportFollowUp extends Model
{
    use HasFactory;

    protected $table = 't_report_follow_up';

    protected $fillable = ['report_id', 'user_id', 'messages'];

    public function report()
    {
        return $this->belongsTo(Report::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function attachments()
    {
        return $this->hasMany(ReportFollowUpAttachment::class, 'report_follow_up_id');
    }
}
