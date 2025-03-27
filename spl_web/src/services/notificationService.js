// src/services/notificationService.js
import { fetchWithAuth } from "../utils/fetchWithAuth";

const BASE_URL = "http://localhost:3000/api/notifications";

export const fetchAdminNotifications = async () => {
  const response = await fetchWithAuth(BASE_URL);
  if (!response.ok) throw new Error("Gagal mengambil notifikasi.");
  const data = await response.json();

  // Filter hanya yang untuk admin
  return (data.notifications || []).filter((notif) => notif.role_target === "admin");
};


export const markNotificationAsRead = async (id) => {
  const response = await fetchWithAuth(`${BASE_URL}/read/${id}`, {
    method: "PUT",
  });
  if (!response.ok) throw new Error("Gagal menandai notifikasi.");
  return await response.json();
};
