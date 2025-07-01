import { fetchWithAuth } from "../utils/fetchWithAuth";

const BASE_URL = "http://localhost:3000/api/admin/villages";

// ✅ Ambil semua desa
export const fetchVillages = async () => {
  const res = await fetchWithAuth(BASE_URL);
  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal mengambil data desa.");
  return data.data; // ⬅️ asumsi `data` berisi array desa
};

// ✅ Ambil desa berdasarkan ID
export const fetchVillageById = async (id) => {
  const res = await fetchWithAuth(`${BASE_URL}/${id}`);
  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal mengambil detail desa.");
  return data.data; // ⬅️ satu objek desa
};

// ✅ Tambah desa baru
export const createVillage = async (formData) => {
  const res = await fetchWithAuth(BASE_URL, {
    method: "POST",
    body: JSON.stringify(formData),
    headers: {
      "Content-Type": "application/json"
    }
  });

  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal membuat desa.");
  return data.data;
};

// ✅ Update desa
export const updateVillage = async (id, formData) => {
  const res = await fetchWithAuth(`${BASE_URL}/${id}`, {
    method: "PUT",
    body: JSON.stringify(formData),
    headers: {
      "Content-Type": "application/json"
    }
  });

  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal mengupdate desa.");
  return data.data;
};

// ✅ Hapus desa
export const deleteVillage = async (id) => {
  const res = await fetchWithAuth(`${BASE_URL}/${id}`, {
    method: "DELETE",
  });
  if (!res.ok) throw new Error("Gagal menghapus desa.");
  return true;
};
