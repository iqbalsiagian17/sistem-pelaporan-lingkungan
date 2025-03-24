// src/context/CarouselContext.jsx
import React, { createContext, useContext, useEffect, useState } from "react";
import {
  fetchCarousels,
  fetchCarouselById,
  createCarousel,
  updateCarousel as updateCarouselService,
  deleteCarousel as deleteCarouselService,
} from "../services/carouselService";

const CarouselContext = createContext();
export const useCarousel = () => useContext(CarouselContext);

export const CarouselProvider = ({ children }) => {
  const [carousels, setCarousels] = useState([]);

  useEffect(() => {
    loadCarousels();
  }, []);

  const loadCarousels = async () => {
    try {
      const data = await fetchCarousels();
      setCarousels(data);
    } catch (error) {
      console.error("Gagal memuat data carousel:", error.message);
    }
  };

  const getCarouselById = async (id) => {
    return await fetchCarouselById(id);
  };

  const addCarousel = async (formData) => {
    const newData = await createCarousel(formData);
    setCarousels((prev) => [newData, ...prev]);
  };

  const updateCarousel = async (id, formData) => {
    const updated = await updateCarouselService(id, formData);
    setCarousels((prev) =>
      prev.map((item) => (item.id === id ? { ...item, ...updated } : item))
    );
    return updated;
  };

  const deleteCarousel = async (id) => {
    await deleteCarouselService(id);
    setCarousels((prev) => prev.filter((item) => item.id !== id));
  };

  return (
    <CarouselContext.Provider
      value={{
        carousels,
        getCarouselById,
        addCarousel,
        updateCarousel, // ✅ pastikan disediakan
        deleteCarousel,
      }}
    >
      {children}
    </CarouselContext.Provider>
  );
};
