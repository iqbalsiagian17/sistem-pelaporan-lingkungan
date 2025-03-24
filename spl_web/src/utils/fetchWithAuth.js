// src/utils/fetchWithAuth.js
export const fetchWithAuth = async (url, options = {}) => {
  const token = localStorage.getItem("accessToken");
  const isFormData = options.body instanceof FormData;

  const headers = {
    ...(isFormData ? {} : { "Content-Type": "application/json" }),
    ...(options.headers || {}),
    Authorization: `Bearer ${token}`,
  };

  const config = {
    ...options,
    headers,
  };

  const response = await fetch(url, config);

  // 🔁 Perpanjang token kalau ada
  const newToken = response.headers.get("x-new-token");
  if (newToken) {
    localStorage.setItem("accessToken", newToken);
    console.log("🔁 Token admin diperpanjang otomatis");
  }

  // ⛔️ Jangan langsung response.json() di sini
  // Cukup kembalikan response untuk di-handle oleh pemanggilnya
  if (response.status === 400 || response.status === 401) {
    const cloned = response.clone(); // ✅ Clone agar response.json() tidak crash
    try {
      const errorData = await cloned.json(); 
      const isTokenInvalid = errorData?.message?.toLowerCase().includes("invalid token");
      const isAlreadyOnLoginPage = window.location.pathname.includes("/auth/login");

      if (isTokenInvalid && !isAlreadyOnLoginPage) {
        alert("⚠️ Sesi Anda telah berakhir. Silakan login ulang.");
        localStorage.removeItem("accessToken");
        window.location.href = "/auth/login";
        return;
      }
    } catch (e) {
      console.warn("❗ Error parsing error response:", e);
    }
  }

  return response; // 💡 response.json() hanya boleh dipanggil di service
};
