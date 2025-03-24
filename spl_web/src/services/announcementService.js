// src/services/announcementService.js
import { fetchWithAuth } from "../utils/fetchWithAuth";

const BASE_URL = "http://localhost:3000/api/admin/announcements";

// Ambil semua pengumuman
export const fetchAnnouncements = async () => {
    const response = await fetchWithAuth(BASE_URL);
    if (!response.ok) throw new Error("Gagal mengambil data pengumuman.");
    const data = await response.json();
    return data.announcements || [];
};

// Ambil pengumuman berdasarkan ID
export const fetchAnnouncementById = async (id) => {
    const response = await fetchWithAuth(`${BASE_URL}/${id}`);
    if (!response.ok) throw new Error("Gagal mengambil detail pengumuman.");
    const data = await response.json();
    return data.announcement;
};

// Tambah pengumuman baru
export const createAnnouncement = async (payload) => {
    const response = await fetchWithAuth(BASE_URL, {
        method: "POST",
        body: payload, // ✅ Langsung kirim FormData
    });
    const data = await response.json();
    if (!response.ok) throw new Error(data.message || "Gagal membuat pengumuman.");
    return data.announcement;
};

// Update pengumuman
export const updateAnnouncement = async (id, payload) => {
    const response = await fetchWithAuth(`${BASE_URL}/${id}`, {
        method: "PUT",
        body: payload, // ✅ Langsung kirim FormData
    });
    const data = await response.json();
    if (!response.ok) throw new Error(data.message || "Gagal mengupdate pengumuman.");
    return data.announcement;
};

// Hapus pengumuman
export const deleteAnnouncement = async (id) => {
  const response = await fetchWithAuth(`${BASE_URL}/${id}`, {
      method: "DELETE"
  });

  if (response.status === 404) {
      console.warn(`⚠️ Pengumuman dengan ID ${id} tidak ditemukan.`);
      return true; // anggap sukses, tidak perlu lempar error
  }

  if (!response.ok) {
      const data = await response.json();
      throw new Error(data.message || "Gagal menghapus pengumuman.");
  }

  return true;
};

