import { fetchWithAuth } from "../utils/fetchWithAuth";

const BASE_URL = "http://69.62.82.58:3000/api/admin/post";

// ✅ Ambil semua post
export const fetchAdminPosts = async () => {
  const res = await fetchWithAuth(BASE_URL);
  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal ambil post.");
  return data.posts;
};

// ✅ Ambil post by ID
export const fetchAdminPostById = async (id) => {
  const res = await fetchWithAuth(`${BASE_URL}/${id}`);
  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal ambil detail post.");
  return data.post;
};

// ✅ Buat post baru
export const createAdminPost = async (formData) => {
  const res = await fetchWithAuth(BASE_URL, {
    method: "POST",
    body: formData,
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal buat post.");
  return data.post;
};

// ✅ Tambahkan komentar ke post
export const createAdminComment = async (body) => {
  const res = await fetchWithAuth(`${BASE_URL}/comment`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal tambah komentar.");
  return data.comment;
};

// ✅ Update post (konten + gambar baru jika ada)
export const updateAdminPost = async (id, formData) => {
  const res = await fetchWithAuth(`${BASE_URL}/${id}`, {
    method: "PUT",
    body: formData,
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal update post.");
  return data.post;
};

export const updateAdminComment = async (id, body) => {
  const res = await fetchWithAuth(`${BASE_URL}/comment/${id}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });

  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal update komentar.");
  return data.comment;
};

// ✅ Delete post
export const deleteAdminPost = async (id) => {
  const res = await fetchWithAuth(`${BASE_URL}/${id}`, {
    method: "DELETE",
  });
  if (!res.ok) throw new Error("Gagal hapus post.");
  return true;
};

// ✅ Delete comment
export const deleteAdminComment = async (id) => {
  const res = await fetchWithAuth(`${BASE_URL}/comment/${id}`, {
    method: "DELETE",
  });
  if (!res.ok) throw new Error("Gagal hapus komentar.");
  return true;
};

// ✅ Pin/unpin post
export const togglePinPost = async (id) => {
  const res = await fetchWithAuth(`${BASE_URL}/pin/${id}`, {
    method: "PUT",
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal update pin.");
  return data.post;
};
