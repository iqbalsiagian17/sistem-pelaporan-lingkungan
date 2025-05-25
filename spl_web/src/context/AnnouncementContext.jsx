import React, { createContext, useContext, useState, useEffect } from 'react';
import {
  fetchAnnouncements as fetchAnnouncementsService,
  fetchAnnouncementById,
  createAnnouncement,
  updateAnnouncement as updateAnnouncementService,
  deleteAnnouncement as deleteAnnouncementService,
} from '../services/announcementService';

// Buat context
const AnnouncementContext = createContext();

// Hook custom untuk mengakses context
export const useAnnouncement = () => useContext(AnnouncementContext);

// Provider
export const AnnouncementProvider = ({ children }) => {
  const [announcements, setAnnouncements] = useState([]);

  // Fetch dari backend
  const fetchAnnouncements = async () => {
    try {
      const data = await fetchAnnouncementsService(); // dari service
      setAnnouncements(data);
      return { success: true };
    } catch (error) {
      console.error("❌ Gagal memuat pengumuman:", error.message);
      return { success: false, error };
    }
  };

  // Panggil sekali saat mount
  useEffect(() => {
    fetchAnnouncements();
  }, []);

  // Get satu pengumuman by ID
  const getAnnouncementById = async (id) => {
    return await fetchAnnouncementById(id);
  };

  // Tambah pengumuman
  const addAnnouncement = async (formData) => {
    const created = await createAnnouncement(formData);
    setAnnouncements((prev) => [created, ...prev]);
  };

  // Update lokal (tanpa API)
  const updateAnnouncementLocal = (id, newData) => {
    setAnnouncements((prev) =>
      prev.map((ann) => (ann.id === id ? { ...ann, ...newData } : ann))
    );
  };

  // Update ke server
  const updateAnnouncement = async (id, formData) => {
    const updated = await updateAnnouncementService(id, formData);
    setAnnouncements((prev) =>
      prev.map((ann) => (ann.id === id ? { ...ann, ...updated } : ann))
    );
    return updated;
  };

  // Delete dari server dan update lokal
  const deleteAnnouncement = async (id) => {
    await deleteAnnouncementService(id);
    setAnnouncements((prev) => prev.filter((ann) => ann.id !== id));
  };

  // Alias: hapus di lokal (jika perlu pakai berbeda)
  const removeAnnouncement = (id) => {
    setAnnouncements((prev) => prev.filter((ann) => ann.id !== id));
  };

  return (
    <AnnouncementContext.Provider
      value={{
        announcements,
        fetchAnnouncements,            // ✅ WAJIB agar bisa dipanggil dari page
        getAnnouncementById,
        addAnnouncement,
        updateAnnouncement,
        deleteAnnouncement,
        removeAnnouncement,
        updateAnnouncementLocal,
      }}
    >
      {children}
    </AnnouncementContext.Provider>
  );
};
