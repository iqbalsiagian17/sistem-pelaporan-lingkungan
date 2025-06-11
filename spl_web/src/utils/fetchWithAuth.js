import { showSessionExpiredModal } from "./modalTrigger";

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

  const newToken = response.headers.get("x-new-token");
  if (newToken) {
    localStorage.setItem("accessToken", newToken);
    console.log("🔁 Token admin diperpanjang otomatis");
  }

  if (response.status === 400 || response.status === 401) {
    const cloned = response.clone();
    try {
      const errorData = await cloned.json();
      const isTokenInvalid = errorData?.message?.toLowerCase().includes("invalid token");
      const isAlreadyOnLoginPage = window.location.pathname.includes("/login");

      const isPublicPath = (pathname) => {
        return [
          "/", // landing page
          "/login",
          "/under-maintenance",
          "/error",
        ].some((path) => pathname.startsWith(path));
      };

      if (
        isTokenInvalid &&
        !isAlreadyOnLoginPage &&
        !isPublicPath(window.location.pathname)
      ) {
        showSessionExpiredModal(); // tampilkan modal hanya jika bukan public
        throw new Error("Token tidak valid atau sudah kadaluarsa");
      }
    } catch (e) {
      console.warn("❗ Error parsing error response:", e);
    }
  }

  return response;
};
