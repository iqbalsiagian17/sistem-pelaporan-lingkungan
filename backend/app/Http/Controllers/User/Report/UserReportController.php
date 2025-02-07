<?php

namespace App\Http\Controllers\User\Report;

use App\Http\Controllers\Controller;
use App\Models\Report;
use App\Models\ReportAttachment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Auth;
use App\Models\ReportFollowUp;
use App\Models\ReportFollowUpAttachment;


class UserReportController extends Controller
{
    public function show($id)
    {
        $report = Report::find($id);

        if (!$report) {
            return response()->json(['message' => 'Laporan tidak ditemukan'], 404);
        }

        return response()->json([
            'message' => 'Laporan ditemukan!',
            'report' => $report
        ], 200);
    }


    // Fungsi untuk membuat laporan baru
    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'date' => 'required|date',
            'district' => 'required|string|max:255',  // Kecamatan wajib
            'village' => 'required|string|max:255',   // Desa/Kelurahan wajib
            'location_details' => 'nullable|string|max:500', // Detail opsional
            'attachments.*' => 'file|mimes:jpg,jpeg,png,pdf|max:2048', // Max 2MB per file
        ]);

        // Simpan laporan
        $report = Report::create([
            'user_id' => Auth::id(),
            'title' => $request->title,
            'description' => $request->description,
            'date' => $request->date,
            'district' => $request->district,
            'village' => $request->village,
            'location_details' => $request->location_details,
            'status' => 'pending',
        ]);

        // Simpan lampiran (jika ada)
        if ($request->hasFile('attachments')) {
            foreach ($request->file('attachments') as $file) {
                // Buat nama file unik
                $filename = time() . '_' . $file->getClientOriginalName();
                $file->move(public_path('reports'), $filename);

                // Simpan informasi file ke database
                ReportAttachment::create([
                    'report_id' => $report->id,
                    'file' => 'reports/' . $filename, // Simpan path file
                ]);
            }
        }

        return response()->json([
            'message' => 'Laporan berhasil dikirim!',
            'report' => $report->load('attachments') // Load attachments untuk respons JSON
        ], 201);
    }

    // Fungsi untuk memperbarui laporan yang sudah dibuat
    public function update(Request $request, $id)
    {
        // Cari laporan berdasarkan ID
        $report = Report::findOrFail($id);

        // Pastikan hanya pemilik laporan atau admin yang bisa mengedit
        if ($report->user_id !== Auth::id()) {
            return response()->json(['message' => 'Anda tidak memiliki izin untuk mengubah laporan ini.'], 403);
        }

        // Validasi input
        $request->validate([
            'title' => 'sometimes|required|string|max:255',
            'description' => 'sometimes|required|string',
            'date' => 'sometimes|required|date',
            'district' => 'sometimes|required|string|max:255',
            'village' => 'sometimes|required|string|max:255',
            'location_details' => 'nullable|string|max:500',
            'attachments.*' => 'file|mimes:jpg,jpeg,png,pdf|max:2048', // Max 2MB per file
        ]);

        // Update laporan dengan data baru
        $report->update($request->only([
            'title', 'description', 'date', 'district', 'village', 'location_details'
        ]));

        // Tambahkan lampiran baru (jika ada)
        if ($request->hasFile('attachments')) {
            foreach ($request->file('attachments') as $file) {
                // Buat nama file unik
                $filename = time() . '_' . $file->getClientOriginalName();
                $file->move(public_path('reports'), $filename);

                // Simpan informasi file ke database
                ReportAttachment::create([
                    'report_id' => $report->id,
                    'file' => 'reports/' . $filename, // Simpan path file
                ]);
            }
        }

        return response()->json([
            'message' => 'Laporan berhasil diperbarui!',
            'report' => $report->load('attachments') // Load attachments untuk respons JSON
        ], 200);
    }

    public function deleteAttachment($id)
    {
        $attachment = ReportAttachment::findOrFail($id);

        // Pastikan hanya pemilik laporan yang bisa menghapus
        if ($attachment->report->user_id !== Auth::id()) {
            return response()->json(['message' => 'Anda tidak memiliki izin untuk menghapus lampiran ini.'], 403);
        }

        // Hapus file dari sistem
        $filePath = public_path($attachment->file);
        if (File::exists($filePath)) {
            File::delete($filePath);
        }

        // Hapus dari database
        $attachment->delete();

        return response()->json(['message' => 'Lampiran berhasil dihapus!'], 200);
    }

    public function addFollowUp(Request $request, $reportId)
    {
        $request->validate([
            'message' => 'required|string|max:1000',
            'attachments.*' => 'file|mimes:jpg,jpeg,png,pdf|max:2048' // Max 2MB per file
        ]);

        $user = Auth::user();
        $report = Report::findOrFail($reportId);

        // Hanya pemilik laporan & admin yang bisa membalas
        if ($user->id !== $report->user_id && $user->type !== 1) {
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
                $file->move(public_path('follow_up_attachments'), $filename);

                ReportFollowUpAttachment::create([
                    'report_follow_up_id' => $followUp->id,
                    'user_id' => $user->id,
                    'file' => 'follow_up_attachments/' . $filename,
                ]);
            }
        }

        return response()->json([
            'message' => 'Balasan berhasil dikirim!',
            'follow_up' => $followUp->load('attachments')
        ], 201);
    }

    public function getFollowUps($reportId)
    {
        $report = Report::with('followUps.user', 'followUps.attachments')->findOrFail($reportId);

        return response()->json([
            'message' => 'Daftar follow-up ditemukan!',
            'follow_ups' => $report->followUps
        ], 200);
    }

    public function deleteFollowUp($followUpId)
    {
        $followUp = ReportFollowUp::findOrFail($followUpId);
        $user = Auth::user();

        // Pastikan hanya admin atau pengirim follow-up yang bisa menghapus
        if ($user->id !== $followUp->user_id && $user->type !== 1) {
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
