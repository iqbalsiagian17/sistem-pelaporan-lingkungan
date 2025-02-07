<?php

namespace App\Http\Controllers\Admin\Report;

use App\Http\Controllers\Controller;
use App\Models\Report;
use App\Models\ReportFollowUp;
use App\Models\ReportFollowUpAttachment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\File;

class AdminReportFollowUpController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    // Admin menambahkan follow-up ke laporan
    public function addFollowUp(Request $request, $reportId)
    {
        $request->validate([
            'message' => 'required|string|max:1000',
            'attachments.*' => 'file|mimes:jpg,jpeg,png,pdf|max:2048' // Max 2MB per file
        ]);

        $user = Auth::user();

        // Pastikan hanya admin yang bisa mengakses controller ini
        if ($user->type != "admin") {
            return response()->json(['message' => 'Hanya admin yang dapat menambahkan follow-up.'], 403);
        }

        $report = Report::findOrFail($reportId);

        // Debug untuk melihat apakah laporan ditemukan
        if (!$report) {
            return response()->json(['message' => 'Laporan tidak ditemukan di dalam controller!'], 404);
        }
        
        // Simpan follow-up oleh admin
        $followUp = ReportFollowUp::create([
            'report_id' => $report->id,
            'user_id' => $user->id,
            'messages' => $request->message,
        ]);

        // Simpan lampiran (jika ada)
        if ($request->hasFile('attachments')) {
            foreach ($request->file('attachments') as $file) {
                $filename = time() . '_' . $file->getClientOriginalName();
                $file->move(public_path('follow_up_attachments'), $filename);

                ReportFollowUpAttachment::create([
                    'report_follow_up_id' => $followUp->id,
                    'user_id' => $user->id,
                    'file' => 'follow_up_attachments/' . $filename,
                ]);
            }
        }

        return response()->json([
            'message' => 'Follow-up berhasil ditambahkan!',
            'follow_up' => $followUp->load('attachments')
        ], 201);
    }

    // Admin melihat semua follow-up dalam laporan tertentu
    public function getFollowUps($reportId)
    {
        $user = Auth::user();

        if ($user->type != "admin") {
            return response()->json(['message' => 'Hanya admin yang dapat melihat follow-up.'], 403);
        }

        $report = Report::with('followUps.user', 'followUps.attachments')->findOrFail($reportId);

        return response()->json([
            'message' => 'Daftar follow-up ditemukan!',
            'follow_ups' => $report->followUps
        ], 200);
    }

    // Admin menghapus follow-up miliknya sendiri
    public function deleteFollowUp($followUpId)
    {
        $followUp = ReportFollowUp::findOrFail($followUpId);
        $user = Auth::user();

        // Pastikan hanya admin yang menghapus komentar miliknya sendiri
        if ($user->id !== $followUp->user_id) {
            return response()->json(['message' => 'Anda tidak memiliki izin untuk menghapus follow-up ini.'], 403);
        }

        // Hapus lampiran terkait
        foreach ($followUp->attachments as $attachment) {
            $filePath = public_path($attachment->file);
            if (File::exists($filePath)) {
                File::delete($filePath);
            }
            $attachment->delete();
        }

        // Hapus follow-up
        $followUp->delete();

        return response()->json(['message' => 'Follow-up berhasil dihapus.'], 200);
    }
}
