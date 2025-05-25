// src/services/analyticsService.js
import { fetchWithAuth } from "../utils/fetchWithAuth";

const BASE_URL = "https://baligebersih.site/api/admin/analytics/overview";

export const fetchOverview = async () => {
  const response = await fetchWithAuth(BASE_URL);
  if (!response.ok) throw new Error("Gagal mengambil data overview analytics.");
  const data = await response.json();
  return data; // Kembalikan semua data: totalReports, completedReports, dll.
};
