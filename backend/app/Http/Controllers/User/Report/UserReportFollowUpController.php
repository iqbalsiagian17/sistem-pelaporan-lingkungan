<?php

namespace App\Http\Controllers\User\Report;

use App\Http\Controllers\Controller;
use App\Models\Report;
use App\Models\ReportFollowUp;
use App\Models\ReportFollowUpAttachment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\File;

class UserReportFollowUpController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    // Menambahkan follow-up (hanya user biasa)
    public function addFollowUp(Request $request, $reportId)
    {
        $request->validate([
            'message' => 'required|string|max:1000',
            'attachments.*' => 'file|mimes:jpg,jpeg,png,pdf|max:2048' // Max 2MB per file
        ]);

        $user = Auth::user();

        // Pastikan user bukan admin
        if ($user->type != "user") {
            return response()->json(['message' => 'Hanya pengguna biasa yang dapat menambahkan follow-up.'], 403);
        }

        $report = Report::findOrFail($reportId);

        // Pastikan user hanya bisa membalas laporan miliknya sendiri
        if ($user->id !== $report->user_id) {
            return response()->json(['message' => 'Anda tidak memiliki izin untuk membalas laporan ini.'], 403);
        }

        // Simpan follow-up
        $followUp = ReportFollowUp::create([
            'report_id' => $report->id,
            'user_id' => $user->id,
            'messages' => $request->message,
        ]);

        // Simpan lampiran (jika ada)
        if ($request->hasFile('attachments')) {
            foreach ($request->file('attachments') as $file) {
                $filename = time() . '_' . $file->getClientOriginalName();
                $filePath = 'follow_up_attachments/' . $filename;

                // Simpan file ke storage publik
                $file->move(public_path('follow_up_attachments'), $filename);

                // Simpan informasi file ke database
                ReportFollowUpAttachment::create([
                    'report_follow_up_id' => $followUp->id,
                    'user_id' => $user->id,
                    'file' => $filePath,
                ]);
            }
        }

        return response()->json([
            'message' => 'Follow-up berhasil dikirim!',
            'follow_up' => $followUp->load('attachments') // Pastikan relasi diload
        ], 201);
    }


    // Mendapatkan semua follow-up untuk laporan tertentu (khusus user biasa)
    public function getFollowUps($reportId)
    {
        $user = Auth::user();

        // Pastikan user bukan admin
        if ($user->type != "user") {
            return response()->json(['message' => 'Hanya pengguna biasa yang dapat melihat follow-up.'], 403);
        }

        $report = Report::with('followUps.user', 'followUps.attachments')
            ->where('user_id', $user->id) // Hanya laporan milik user tersebut
            ->findOrFail($reportId);

        return response()->json([
            'message' => 'Daftar follow-up ditemukan!',
            'follow_ups' => $report->followUps
        ], 200);
    }

    // Menghapus follow-up (hanya oleh user biasa jika follow-up miliknya)
    public function deleteFollowUp($followUpId)
    {
        $followUp = ReportFollowUp::findOrFail($followUpId);
        $user = Auth::user();

        // Pastikan hanya pemilik follow-up yang bisa menghapus
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
