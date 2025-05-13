import axios from "axios";

const API_BASE_URL = "http://69.62.82.58:3000"; // Base URL untuk server lokal

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    "Content-Type": "application/json",
  },
});

// Interceptor untuk menyisipkan token di setiap request
api.interceptors.request.use((config) => {
  const token = localStorage.getItem("authToken");
  if (token) {
      config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export default api;
