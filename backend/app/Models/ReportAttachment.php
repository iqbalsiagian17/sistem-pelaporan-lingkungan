<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ReportAttachment extends Model
{
    use HasFactory;

    protected $table = 't_report_attachment';

    protected $fillable = ['report_id', 'file'];

    public function report()
    {
        return $this->belongsTo(Report::class);
    }
}
