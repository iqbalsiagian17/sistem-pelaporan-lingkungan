import React, { createContext, useContext, useEffect, useState } from "react";
import {
  fetchMediaCarousels,
  fetchMediaCarouselById,
  createMediaCarousels,
  updateMediaCarousels,
  deleteMediaCarousels,
} from "../services/mediaCarouselService";

// Buat context
const MediaCarouselContext = createContext();

// Custom hook
export const useMediaCarousel = () => useContext(MediaCarouselContext);

// Provider
export const MediaCarouselProvider = ({ children }) => {
  const [mediaCarousels, setMediaCarousels] = useState([]);

  useEffect(() => {
    loadMediaCarousels();
  }, []);

  // Muat semua data
  const loadMediaCarousels = async () => {
    try {
      const data = await fetchMediaCarousels();
      setMediaCarousels(data);
    } catch (error) {
      console.error("❌ Gagal memuat media carousel:", error.message);
    }
  };

  // Ambil berdasarkan ID
  const getMediaCarouselById = async (id) => {
    try {
      return await fetchMediaCarouselById(id);
    } catch (error) {
      console.error(`❌ Gagal mengambil media carousel ID ${id}:`, error.message);
      throw error;
    }
  };

  // Tambah baru
  const addMediaCarousel = async (formData) => {
    try {
      const newCarousel = await createMediaCarousels(formData);
      setMediaCarousels((prev) => [newCarousel, ...prev]);
      return newCarousel;
    } catch (error) {
      console.error("❌ Gagal menambahkan media carousel:", error.message);
      throw error;
    }
  };

  // Update
  const updateMediaCarousel = async (id, formData) => {
    try {
      const updated = await updateMediaCarousels(id, formData);
      setMediaCarousels((prev) =>
        prev.map((item) => (item.id === id ? { ...item, ...updated } : item))
      );
      return updated;
    } catch (error) {
      console.error(`❌ Gagal mengupdate media carousel ID ${id}:`, error.message);
      throw error;
    }
  };

  // Hapus
  const deleteMediaCarousel = async (id) => {
    try {
      await deleteMediaCarousels(id);
      setMediaCarousels((prev) => prev.filter((item) => item.id !== id));
    } catch (error) {
      console.error(`❌ Gagal menghapus media carousel ID ${id}:`, error.message);
      throw error;
    }
  };

  return (
    <MediaCarouselContext.Provider
      value={{
        mediaCarousels,
        getMediaCarouselById,
        addMediaCarousel,
        updateMediaCarousel,
        deleteMediaCarousel,
      }}
    >
      {children}
    </MediaCarouselContext.Provider>
  );
};
