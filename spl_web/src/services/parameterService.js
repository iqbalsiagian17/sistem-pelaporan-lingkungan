// src/services/parameterService.js
import { fetchWithAuth } from "../utils/fetchWithAuth";

const BASE_URL = "http://localhost:3000/api/admin/parameters";

// Ambil semua parameter (meskipun hanya 1 row)
export const getAllParameters = async () => {
  const response = await fetchWithAuth(BASE_URL);
  if (!response.ok) throw new Error("Gagal mengambil data parameter.");
  const data = await response.json();
  return data.data || [];
};

// Update parameter (ID tetap 1 di backend)
export const updateParameter = async (id, payload) => {
  const response = await fetchWithAuth(`${BASE_URL}/${id}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });

  const data = await response.json();
  if (!response.ok) throw new Error(data.message || "Gagal memperbarui parameter.");
  return data.data;
};


// Buat parameter (jika belum ada)
export const createParameter = async (payload) => {
  const response = await fetchWithAuth(BASE_URL, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });
  const data = await response.json();
  if (!response.ok) throw new Error(data.message || "Gagal membuat parameter.");
  return data.data;
};

// Hapus parameter (opsional, ID tetap 1)
export const deleteParameter = async () => {
  const response = await fetchWithAuth(BASE_URL, {
    method: "DELETE",
  });
  const data = await response.json();
  if (!response.ok) throw new Error(data.message || "Gagal menghapus parameter.");
  return true;
};
