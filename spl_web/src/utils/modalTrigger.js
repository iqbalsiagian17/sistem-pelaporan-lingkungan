let modalRef = null;

export const setModalRef = (ref) => {
  modalRef = ref;
};

export const showSessionExpiredModal = () => {
  console.log("🔥 showSessionExpiredModal dipanggil");
  if (modalRef) {
    modalRef({
      title: "Sesi Anda Telah Berakhir",
      body: "Untuk keamanan, sesi Anda telah berakhir. Silakan login ulang untuk melanjutkan.",
      confirmText: "Login Sekarang",
      showCancelButton: false, // 🔧 bisa diubah ke true jika nanti mau ada tombol batal
      cancelText: "Batal",
      onConfirm: () => {
        localStorage.removeItem("accessToken");
        setTimeout(() => {
          window.location.href = "/login";
        }, 300);
      },
      onCancel: () => {
        console.log("❌ User batal login ulang");
      },
    });
  } else {
    console.warn("❗ ModalRef belum diinisialisasi");
  }
};
