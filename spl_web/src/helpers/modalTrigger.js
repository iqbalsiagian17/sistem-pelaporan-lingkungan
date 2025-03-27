import { toast } from "react-toastify";

// Helper untuk menampilkan notifikasi token kadaluarsa
export const showSessionExpiredModal = () => {
  if (typeof window !== "undefined") {
    toast.error("Sesi kamu telah berakhir. Silakan login kembali.", {
      position: "top-center",
      autoClose: 3000,
      hideProgressBar: false,
      closeOnClick: true,
      pauseOnHover: false,
      draggable: true,
      theme: "colored",
      onClose: () => {
        // Bersihkan token dan redirect
        localStorage.removeItem("accessToken");
        localStorage.removeItem("user");
        window.location.href = "/auth/login";
      },
    });
  }
};
