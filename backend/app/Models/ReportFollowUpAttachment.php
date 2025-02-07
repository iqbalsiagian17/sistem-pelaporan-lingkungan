<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ReportFollowUpAttachment extends Model
{
    use HasFactory;

    protected $table = 't_report_follow_up_attachment';

    protected $fillable = ['report_follow_up_id', 'user_id', 'file'];

    public function followUp()
    {
        return $this->belongsTo(ReportFollowUp::class, 'report_follow_up_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
