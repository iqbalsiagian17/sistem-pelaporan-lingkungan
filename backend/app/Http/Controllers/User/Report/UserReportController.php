<?php

namespace App\Http\Controllers\User\Report;

use App\Http\Controllers\Controller;
use App\Models\Report;
use App\Models\ReportAttachment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Auth;
use App\Models\ReportFollowUp;
use Illuminate\Support\Facades\DB;
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

            // Validasi lokasi
            'is_at_location' => 'required|boolean',
            'latitude' => 'nullable|required_if:is_at_location,1|numeric',
            'longitude' => 'nullable|required_if:is_at_location,1|numeric',
            'location_details' => 'sometimes|nullable|string|max:500|required_if:is_at_location,1',

            'district' => 'nullable|required_if:is_at_location,0|string|max:255',
            'village' => 'nullable|required_if:is_at_location,0|string|max:255',

            // Validasi lampiran (opsional)
            'attachments.*' => 'file|mimes:jpg,jpeg,png,pdf|max:10000', // Max 2MB per file
        ]);

        return DB::transaction(function () use ($request) {
            // Simpan laporan ke database
            $report = Report::create([
                'user_id' => Auth::id(),
                'title' => $request->title,
                'description' => $request->description,
                'date' => $request->date,
                'status' => 'pending',
                'likes' => 0,
                
                // Penyimpanan lokasi berdasarkan opsi yang dipilih user
                'latitude' => $request->is_at_location ? $request->latitude : null,
                'longitude' => $request->is_at_location ? $request->longitude : null,
                'location_details' => $request->is_at_location ? $request->location_details : null,
                'district' => !$request->is_at_location ? $request->district : null,
                'village' => !$request->is_at_location ? $request->village : null,
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
                'report' => $report->load('attachments') // Load attachments dalam respons JSON
            ], 201);
        });
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

        // Cek apakah status masih "pending"
        if ($report->status !== 'pending') {
            return response()->json(['message' => 'Laporan tidak dapat diedit karena statusnya sudah ' . $report->status], 403);
        }

        // Validasi input
        $request->validate([
            'title' => 'sometimes|required|string|max:255',
            'description' => 'sometimes|required|string',
            'date' => 'sometimes|required|date',

            // Validasi lokasi
            'is_at_location' => 'sometimes|required|boolean',
            'latitude' => 'nullable|required_if:is_at_location,1|numeric',
            'longitude' => 'nullable|required_if:is_at_location,1|numeric',
            'location_details' => 'sometimes|nullable|string|max:500|required_if:is_at_location,1',

            'district' => 'nullable|required_if:is_at_location,0|string|max:255',
            'village' => 'nullable|required_if:is_at_location,0|string|max:255',

            // Validasi lampiran (opsional)
            'attachments.*' => 'file|mimes:jpg,jpeg,png,pdf|max:2048', // Max 2MB per file
        ]);

        return DB::transaction(function () use ($request, $report) {
            // Update data laporan dengan input terbaru
            $report->update([
                'title' => $request->title ?? $report->title,
                'description' => $request->description ?? $report->description,
                'date' => $request->date ?? $report->date,

                // Penyimpanan lokasi berdasarkan opsi yang dipilih user
                'latitude' => $request->is_at_location ? $request->latitude : null,
                'longitude' => $request->is_at_location ? $request->longitude : null,
                'location_details' => $request->is_at_location ? $request->location_details : null,
                'district' => !$request->is_at_location ? $request->district : null,
                'village' => !$request->is_at_location ? $request->village : null,
            ]);

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
                'report' => $report->load('attachments') // Load attachments dalam respons JSON
            ], 200);
        });
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
