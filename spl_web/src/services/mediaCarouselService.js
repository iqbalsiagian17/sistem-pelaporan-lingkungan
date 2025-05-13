import { fetchWithAuth } from "../utils/fetchWithAuth";

const BASE_URL = "http://69.62.82.58:3000/api/admin/mediacarousels";

// Ambil semua
export const fetchMediaCarousels = async () => {
  const res = await fetchWithAuth(BASE_URL);
  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal mengambil media carousel.");
  return data.mediacarousels;
};

// Ambil satu
export const fetchMediaCarouselById = async (id) => {
  const res = await fetchWithAuth(`${BASE_URL}/${id}`);
  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal mengambil detail media carousel.");
  return data.mediacarousel;
};

// Tambah baru
export const createMediaCarousels = async (formData) => {
  const res = await fetchWithAuth(BASE_URL, {
    method: "POST",
    body: formData, 
  });

  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal membuat media carousel.");
  return data.mediacarousel;
};

// Update
export const updateMediaCarousels = async (id, formData) => {
  const res = await fetchWithAuth(`${BASE_URL}/${id}`, {
    method: "PUT",
    body: formData,
  });

  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal mengupdate media carousel.");
  return data.mediacarousel;
};

// Hapus
export const deleteMediaCarousels = async (id) => {
  const res = await fetchWithAuth(`${BASE_URL}/${id}`, {
    method: "DELETE",
  });
  if (!res.ok) throw new Error("Gagal menghapus media carousel.");
  return true;
};
