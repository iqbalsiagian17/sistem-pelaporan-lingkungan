import { fetchWithAuth } from "../utils/fetchWithAuth";

const BASE_URL = "http://localhost:3000/api/admin/parameters";

// Ambil semua parameter (meskipun hanya 1 row)
export const getAllParameters = async () => {
  const response = await fetchWithAuth(BASE_URL);
  if (!response.ok) throw new Error("Gagal mengambil data parameter.");
  const data = await response.json();
  return data.data || [];
};

// ✅ Update parameter (dengan FormData)
export const updateParameter = async (id, formData) => {
  const response = await fetchWithAuth(`${BASE_URL}/${id}`, {
    method: "PUT",
    body: formData,
  });

  const text = await response.text();
  let data;

  try {
    data = JSON.parse(text);
  } catch (e) {
    console.error("❌ Gagal parsing JSON:", e);
    console.warn("🧾 Response mentah:", text);
    throw new Error("Server mengembalikan response tidak valid. Cek server.");
  }

  if (!response.ok) throw new Error(data.message || "Gagal memperbarui parameter.");
  return data.data;
};


// ✅ Create parameter (dengan FormData)
export const createParameter = async (formData) => {
  const response = await fetchWithAuth(BASE_URL, {
    method: "POST",
    body: formData, // kirim FormData langsung
  });

  const text = await response.text();
  let data;

  try {
    data = JSON.parse(text);
  } catch (e) {
    console.error("❌ Gagal parsing JSON:", e);
    console.warn("🧾 Response mentah:", text);
    throw new Error("Server mengembalikan response tidak valid. Cek server.");
  }

  if (!response.ok) throw new Error(data.message || "Gagal membuat parameter.");
  return data.data;
};


// Hapus parameter (opsional)
export const deleteParameter = async (id) => {
  const response = await fetchWithAuth(`${BASE_URL}/${id}`, {
    method: "DELETE",
  });
  const data = await response.json();
  if (!response.ok) throw new Error(data.message || "Gagal menghapus parameter.");
  return true;
};
