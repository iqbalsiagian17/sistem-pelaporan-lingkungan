// src/services/reportService.js
import { fetchWithAuth } from "../utils/fetchWithAuth";

const BASE_URL = "http://localhost:3000/api/admin/reports";

// Ambil semua laporan
export const getAllReports = async () => {
    const response = await fetchWithAuth(BASE_URL);
    if (!response.ok) throw new Error("Gagal mengambil laporan.");
    const data = await response.json();
    return data.reports || [];
};

// Ambil detail laporan berdasarkan ID
export const getReportById = async (id) => {
    const response = await fetchWithAuth(`${BASE_URL}/${id}`);
    if (!response.ok) throw new Error("Gagal mengambil detail laporan.");
    const data = await response.json();
    return data.report;
};

// Ubah status laporan
export const updateReportStatus = async (id, payload, evidences = []) => {
    const formData = new FormData();
    formData.append("new_status", payload.new_status);
    formData.append("message", payload.message);
    evidences.forEach((file) => {
      formData.append("evidences", file); // 👈 ini harus sama!
    });
  
    const response = await fetchWithAuth(`${BASE_URL}/${id}/status`, {
      method: "PUT",
      body: formData,
    });
  
    const data = await response.json();
    if (!response.ok) throw new Error(data.message || "Gagal mengubah status laporan.");
    return data;
  };

  

// Hapus laporan
export const deleteReport = async (id) => {
    const response = await fetchWithAuth(`${BASE_URL}/${id}`, {
        method: "DELETE"
    });
    if (!response.ok) throw new Error("Gagal menghapus laporan.");
    return true;
};
