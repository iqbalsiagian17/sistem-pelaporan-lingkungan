import { createContext, useContext, useState, useEffect } from "react";
import ConfirmModal from "../components/common/ConfirmModal";
import { setModalRef } from "../utils/modalTrigger"; // <== penting

const ModalContext = createContext();

export const useModal = () => useContext(ModalContext);

export const ModalProvider = ({ children }) => {
  const [modal, setModal] = useState({
    show: false,
    title: "",
    body: "",
    confirmText: "Oke",
    variant: "primary",
    onConfirm: () => {},
  });

  const showConfirm = ({ title, body, confirmText, variant, onConfirm }) => {
    setModal({
      show: true,
      title,
      body,
      confirmText,
      variant,
      onConfirm,
    });
  };

  const hideModal = () => {
    setModal((prev) => ({ ...prev, show: false }));
  };

  // 🔗 Registrasi showConfirm ke trigger global
  useEffect(() => {
    setModalRef(showConfirm);
  }, []);

  return (
    <ModalContext.Provider value={{ showConfirm }}>
      {children}
      <ConfirmModal
        show={modal.show}
        onHide={hideModal}
        onConfirm={() => {
          modal.onConfirm();
          hideModal();
        }}
        title={modal.title}
        body={modal.body}
        confirmText={modal.confirmText}
        variant={modal.variant}
      />
    </ModalContext.Provider>
  );
};
