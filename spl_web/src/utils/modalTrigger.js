// src/utils/modalTrigger.js

let modalRef = null;

/**
 * Menyimpan referensi fungsi pemanggil modal global.
 * @param {Function} ref - Fungsi untuk membuka modal.
 */
export const setModalRef = (ref) => {
  modalRef = ref;
};

/**
 * Menampilkan modal sesi berakhir yang wajib login ulang.
 */
export const showSessionExpiredModal = () => {
  if (modalRef) {
    modalRef({
      title: "Sesi Anda Telah Berakhir",
      body: "Untuk keamanan, sesi Anda telah berakhir. Silakan login ulang untuk melanjutkan.",
      confirmText: "Login Sekarang",
      variant: "warning",
      disableBackdropClick: true, // ⛔ Tidak bisa klik di luar modal
      disableEscapeKeyDown: true, // ⛔ Tidak bisa tekan ESC untuk menutup
      onlyConfirmButton: true,    // ✅ Hanya tombol konfirmasi, tanpa tombol cancel
      onConfirm: () => {
        // Hapus accessToken dari localStorage
        localStorage.removeItem("accessToken");

        // Tunggu sedikit supaya animasi modal menutup sempurna
        setTimeout(() => {
          window.location.href = "/auth/login";
        }, 300);
      },
    });
  } else {
    console.warn("❗ ModalRef belum diinisialisasi. Tidak dapat menampilkan modal sesi berakhir.");
  }
};
