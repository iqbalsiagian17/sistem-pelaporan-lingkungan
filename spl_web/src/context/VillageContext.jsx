import { createContext, useContext, useEffect, useState } from "react";
import {
  fetchVillages,
  fetchVillageById,
  createVillage,
  updateVillage,
  deleteVillage,
} from "../services/villageService";

// 1. Buat Context
const VillageContext = createContext();
export const useVillage = () => useContext(VillageContext);

// 2. Buat Provider
export const VillageProvider = ({ children }) => {
  const [villages, setVillages] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  // Ambil semua desa
  const loadVillages = async () => {
    setIsLoading(true);
    try {
      const data = await fetchVillages();
      setVillages(data);
    } catch (error) {
      console.error("❌ Gagal memuat daftar desa:", error.message);
    } finally {
      setIsLoading(false);
    }
  };

  // Jalankan otomatis saat mount
  useEffect(() => {
    loadVillages();
  }, []);

  // Fungsi CRUD
  const getVillageById = async (id) => {
    return await fetchVillageById(id);
  };

  const addVillage = async (formData) => {
    const newVillage = await createVillage(formData);
    setVillages((prev) => [newVillage, ...prev]);
    return newVillage;
  };

  const updateVillageById = async (id, formData) => {
    const updated = await updateVillage(id, formData);
    setVillages((prev) =>
      prev.map((item) => (item.id === id ? { ...item, ...updated } : item))
    );
    return updated;
  };

  const deleteVillageById = async (id) => {
    await deleteVillage(id);
    setVillages((prev) => prev.filter((item) => item.id !== id));
  };

  return (
    <VillageContext.Provider
      value={{
        villages,
        isLoading,
        getVillageById,
        addVillage,
        updateVillageById,
        deleteVillageById,
        loadVillages,
      }}
    >
      {children}
    </VillageContext.Provider>
  );
};
