// src/utils/modalTrigger.js
let modalRef = null;

export const setModalRef = (ref) => {
  modalRef = ref;
};

export const showSessionExpiredModal = () => {
  if (modalRef) {
    modalRef({
      title: "⚠️ Sesi Berakhir",
      body: "Sesi Anda telah berakhir. Silakan login ulang.",
      confirmText: "Login Ulang",
      variant: "warning",
      onConfirm: () => {
        localStorage.removeItem("accessToken");
        window.location.href = "/auth/login";
      },
    });
  } else {
    console.warn("❗ ModalRef belum siap digunakan.");
  }
};
