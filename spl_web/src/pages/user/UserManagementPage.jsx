import { useUser } from "../../context/UserContext";
import { useState, useEffect } from "react";
import UserTable from "./components/UserTable";
import UserBlockModal from "./components/UserBlockModal";
import UserEditModal from "./components/UserEditModal";
import UserChangePasswordModal from "./components/UserChangePasswordModal";
import ConfirmModal from "../../components/common/ConfirmModal";
import ToastNotification from "../../components/common/ToastNotification";
import UserDetailModal from "./components/UserDetailModal";
import { getUserDetails } from "../../services/userService";

const UserManagementPage = () => {
  const {
    users,
    deleteUser,
    blockUser,
    unblockUser,
    updateUser,
    removeUser,
    updateUserLocal,
    changeUserPassword,
    fetchUsers, // ✅ kalau kamu punya fungsi ini di context
  } = useUser();

  const [selectedUser, setSelectedUser] = useState(null);
  const [showBlockModal, setShowBlockModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [showPasswordModal, setShowPasswordModal] = useState(false);
  const [blockingUntil, setBlockingUntil] = useState("");
  const [showDetailModal, setShowDetailModal] = useState(false);
  const [detailUser, setDetailUser] = useState(null);
  const [isLoading, setIsLoading] = useState(true); // ✅ untuk kontrol loading awal

  const [toast, setToast] = useState({
    show: false,
    message: "",
    variant: "success",
  });

  const showToast = (message, variant = "success") => {
    setToast({ show: true, message, variant });
  };

  // ✅ Ambil data user saat pertama render
  useEffect(() => {
    const loadUsers = async () => {
      setIsLoading(true);
      try {
        await fetchUsers?.(); // ❗ pastikan fungsi fetchUsers ada di context kamu
      } catch (err) {
        showToast("Gagal memuat data pengguna", "danger");
      } finally {
        setIsLoading(false);
      }
    };
    loadUsers();
  }, []);

  const handleDelete = (user) => {
    setSelectedUser(user);
    setShowDeleteModal(true);
  };

  const confirmDelete = async () => {
    await deleteUser(selectedUser.id);
    removeUser(selectedUser.id);
    setShowDeleteModal(false);
    showToast("Pengguna berhasil dihapus", "success");
  };

  const handleBlock = (user) => {
    setSelectedUser(user);
    setBlockingUntil("");
    setShowBlockModal(true);
  };

  const confirmBlock = async () => {
    if (!blockingUntil) {
      showToast("Tanggal blokir wajib diisi!", "danger");
      return;
    }
    await blockUser(selectedUser.id, blockingUntil);
    updateUserLocal(selectedUser.id, { blocked_until: blockingUntil });
    setBlockingUntil("");
    setShowBlockModal(false);
    showToast("Pengguna berhasil diblokir", "success");
  };

  const handleUnblock = async (user) => {
    await unblockUser(user.id);
    updateUserLocal(user.id, { blocked_until: null });
    showToast("Pengguna berhasil di-unblock", "success");
  };

  const handleEdit = (user) => {
    setSelectedUser(user);
    setShowEditModal(true);
  };

  const confirmEdit = async (id, newData) => {
    await updateUser(id, newData);
    updateUserLocal(id, newData);
    setShowEditModal(false);
    showToast("Data pengguna berhasil diperbarui", "success");
  };

  const handleChangePassword = (user) => {
    setSelectedUser(user);
    setShowPasswordModal(true);
  };

  const confirmChangePassword = async (id, newPassword) => {
    await changeUserPassword(id, newPassword);
    setShowPasswordModal(false);
    showToast("Password berhasil diubah", "success");
  };

  const handleViewDetail = async (userId) => {
    const data = await getUserDetails(userId);
    setDetailUser(data);
    setShowDetailModal(true);
  };

  return (
    <div>
      <UserTable
        users={users}
        isLoading={isLoading} // ✅ kirim status loading ke UserTable
        onDelete={handleDelete}
        onBlock={handleBlock}
        onUnblock={handleUnblock}
        onEdit={handleEdit}
        onChangePassword={handleChangePassword}
        onDetail={handleViewDetail}
      />

      <UserBlockModal
        show={showBlockModal}
        onHide={() => setShowBlockModal(false)}
        onConfirm={confirmBlock}
        blockingUntil={blockingUntil}
        setBlockingUntil={setBlockingUntil}
      />

      <UserEditModal
        show={showEditModal}
        onHide={() => setShowEditModal(false)}
        user={selectedUser}
        onSave={confirmEdit}
      />

      <UserChangePasswordModal
        show={showPasswordModal}
        onHide={() => setShowPasswordModal(false)}
        user={selectedUser}
        onConfirm={confirmChangePassword}
      />

      <ConfirmModal
        show={showDeleteModal}
        onHide={() => setShowDeleteModal(false)}
        onConfirm={confirmDelete}
        title="Hapus Pengguna"
        body={`Apakah kamu yakin ingin menghapus pengguna ${selectedUser?.username}?`}
        confirmText="Hapus"
        variant="danger"
      />

      <ToastNotification
        show={toast.show}
        onClose={() => setToast({ ...toast, show: false })}
        message={toast.message}
        title={toast.variant === "danger" ? "Gagal" : "Berhasil"}
        variant={toast.variant}
      />

      <UserDetailModal
        show={showDetailModal}
        onHide={() => setShowDetailModal(false)}
        user={detailUser}
      />
    </div>
  );
};

export default UserManagementPage;
