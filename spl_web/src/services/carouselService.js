import { fetchWithAuth } from "../utils/fetchWithAuth";

const BASE_URL = "http://localhost:3000/api/admin/carousels";

export const fetchCarousels = async () => {
  const res = await fetchWithAuth(BASE_URL);
  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal ambil carousel.");
  return data.carousels;
};

export const fetchCarouselById = async (id) => {
  const res = await fetchWithAuth(`${BASE_URL}/${id}`);
  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal ambil detail.");
  return data.carousel;
};

export const createCarousel = async (formData) => {
  const res = await fetchWithAuth(BASE_URL, {
    method: "POST",
    body: formData,
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal buat carousel.");
  return data.carousel;
};

export const updateCarousel = async (id, formData) => {
    const res = await fetchWithAuth(`${BASE_URL}/${id}`, {
      method: "PUT",
      body: formData,
    });
  
    // ⛔️ res.json() hanya boleh dipanggil sekali!
    const data = await res.json();
  
    if (!res.ok) throw new Error(data.message || "Gagal update carousel.");
    return data.carousel;
  };
  

export const deleteCarousel = async (id) => {
  const res = await fetchWithAuth(`${BASE_URL}/${id}`, {
    method: "DELETE",
  });
  if (!res.ok) throw new Error("Gagal hapus carousel.");
  return true;
};
