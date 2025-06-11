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

// Hook custom untuk gunakan context ini
export const useAnnouncement = () => useContext(AnnouncementContext);

// Provider utama
export const AnnouncementProvider = ({ children }) => {
  const [announcements, setAnnouncements] = useState([]);

  // ✅ Hanya fetch jika user sudah login
  const fetchAnnouncements = async () => {
    try {
      const token = localStorage.getItem("accessToken");
      if (!token) {
        console.log("🔒 User belum login. Tidak fetch pengumuman.");
        return { success: false, error: "Not authenticated" };
      }

      const data = await fetchAnnouncementsService(); // panggil service
      setAnnouncements(data);
      return { success: true };
    } catch (error) {
      console.error("❌ Gagal memuat pengumuman:", error.message);
      return { success: false, error };
    }
  };

  useEffect(() => {
    fetchAnnouncements();
  }, []);

  const getAnnouncementById = async (id) => {
    return await fetchAnnouncementById(id);
  };

  const addAnnouncement = async (formData) => {
    const created = await createAnnouncement(formData);
    setAnnouncements((prev) => [created, ...prev]);
  };

  const updateAnnouncement = async (id, formData) => {
    const updated = await updateAnnouncementService(id, formData);
    setAnnouncements((prev) =>
      prev.map((ann) => (ann.id === id ? { ...ann, ...updated } : ann))
    );
    return updated;
  };

  const updateAnnouncementLocal = (id, newData) => {
    setAnnouncements((prev) =>
      prev.map((ann) => (ann.id === id ? { ...ann, ...newData } : ann))
    );
  };

  const deleteAnnouncement = async (id) => {
    await deleteAnnouncementService(id);
    setAnnouncements((prev) => prev.filter((ann) => ann.id !== id));
  };

  const removeAnnouncement = (id) => {
    setAnnouncements((prev) => prev.filter((ann) => ann.id !== id));
  };

  return (
    <AnnouncementContext.Provider
      value={{
        announcements,
        fetchAnnouncements,
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
