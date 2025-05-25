import React, { createContext, useContext, useEffect, useState } from "react";
import {
  fetchMediaCarousels,
  fetchMediaCarouselById,
  createMediaCarousels,
  updateMediaCarousels,
  deleteMediaCarousels,
} from "../services/mediaCarouselService";

const MediaCarouselContext = createContext();
export const useMediaCarousel = () => useContext(MediaCarouselContext);

export const MediaCarouselProvider = ({ children }) => {
  const [mediaCarousels, setMediaCarousels] = useState([]);
  const [isLoading, setIsLoading] = useState(true); // ✅ pastikan default = true

  const loadMediaCarousels = async () => {
    setIsLoading(true); // ✅ atur loading saat mulai fetch
    try {
      const data = await fetchMediaCarousels();
      setMediaCarousels(data);
    } catch (error) {
      console.error("❌ Gagal memuat media carousel:", error.message);
    } finally {
      setIsLoading(false); // ✅ hanya false setelah selesai
    }
  };

  useEffect(() => {
    loadMediaCarousels(); // otomatis fetch saat pertama kali render
  }, []);

  const getMediaCarouselById = async (id) => {
    return await fetchMediaCarouselById(id);
  };

  const addMediaCarousel = async (formData) => {
    const newCarousel = await createMediaCarousels(formData);
    setMediaCarousels((prev) => [newCarousel, ...prev]);
    return newCarousel;
  };

  const updateMediaCarousel = async (id, formData) => {
    const updated = await updateMediaCarousels(id, formData);
    setMediaCarousels((prev) =>
      prev.map((item) => (item.id === id ? { ...item, ...updated } : item))
    );
    return updated;
  };

  const deleteMediaCarousel = async (id) => {
    await deleteMediaCarousels(id);
    setMediaCarousels((prev) => prev.filter((item) => item.id !== id));
  };

  return (
    <MediaCarouselContext.Provider
      value={{
        mediaCarousels,
        isLoading,
        getMediaCarouselById,
        addMediaCarousel,
        updateMediaCarousel,
        deleteMediaCarousel,
        loadMediaCarousels, // optional jika mau trigger ulang
      }}
    >
      {children}
    </MediaCarouselContext.Provider>
  );
};
