import React, { createContext, useContext, useState, useEffect } from 'react';
import {
  fetchAnnouncements,
  fetchAnnouncementById,
  createAnnouncement,
  updateAnnouncement as updateAnnouncementService,
  deleteAnnouncement as deleteAnnouncementService, 
} from '../services/announcementService';

const AnnouncementContext = createContext();
export const useAnnouncement = () => useContext(AnnouncementContext);

export const AnnouncementProvider = ({ children }) => {
  const [announcements, setAnnouncements] = useState([]);

  useEffect(() => {
    const loadAnnouncements = async () => {
      try {
        const data = await fetchAnnouncements();
        setAnnouncements(data);
      } catch (error) {
        console.error("❌ Gagal memuat pengumuman:", error.message);
      }
    };
    loadAnnouncements();
  }, []);

  const getAnnouncementById = async (id) => {
    return await fetchAnnouncementById(id);
  };

  const addAnnouncement = async (formData) => {
    const created = await createAnnouncement(formData); // backend ambil user_id dari token
    setAnnouncements((prev) => [created, ...prev]);
  };


  const updateAnnouncementLocal = (id, newData) => {
    setAnnouncements((prev) =>
      prev.map((ann) => (ann.id === id ? { ...ann, ...newData } : ann))
    );
  };

  const updateAnnouncement = async (id, formData) => {
    const updated = await updateAnnouncementService(id, formData); // backend ambil user_id dari token
    setAnnouncements((prev) =>
      prev.map((ann) => (ann.id === id ? { ...ann, ...updated } : ann))
    );
    return updated;
  };

  const removeAnnouncement = async (id) => {
    await deleteAnnouncement(id);
    setAnnouncements((prev) => prev.filter((ann) => ann.id !== id));
  };

  const deleteAnnouncement = async (id) => {
    await deleteAnnouncementService(id);
    setAnnouncements((prev) => prev.filter((ann) => ann.id !== id));
  };

  return (
    <AnnouncementContext.Provider
      value={{
        announcements,
        getAnnouncementById,
        addAnnouncement,
        updateAnnouncement,  
        deleteAnnouncement,      // ✅ ini yang harus tersedia
        removeAnnouncement,
        updateAnnouncementLocal,
      }}
    >
      {children}
    </AnnouncementContext.Provider>
  );
};



