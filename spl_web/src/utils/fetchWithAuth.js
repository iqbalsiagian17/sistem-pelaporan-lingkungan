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

  // Tangani error token invalid/expired
  if (response.status === 400 || response.status === 401) {
    const cloned = response.clone();
try {
  const errorData = await cloned.json();
  const message = errorData?.message?.toLowerCase?.() || "";

  const isTokenInvalid = message.includes("invalid token");
  const isAlreadyOnLoginPage = window.location.pathname.includes("/login");
  const currentPath = window.location.pathname;

const isPublicPath = (pathname) => {
  return [
    "/", 
    "/login",
    "/under-maintenance",
    "/error"
  ].some((path) => path === pathname); // ⬅️ hanya cocok jika sama persis
};


  console.log("💡 Analisa:");
  console.log("🔹 isTokenInvalid:", isTokenInvalid);
  console.log("🔹 isAlreadyOnLoginPage:", isAlreadyOnLoginPage);
  console.log("🔹 isPublicPath:", isPublicPath(currentPath));
  console.log("🔹 currentPath:", currentPath);

  if (isTokenInvalid && !isAlreadyOnLoginPage && !isPublicPath(currentPath)) {
    console.log("🔥 Kondisi terpenuhi, panggil showSessionExpiredModal()");
    requestAnimationFrame(() => {
      showSessionExpiredModal();
    });
    throw new Error("Token tidak valid atau sudah kadaluarsa");
  }
} catch (e) {
  console.warn("❗ Gagal parsing error JSON:", e);
}
  }

  return response;
};
