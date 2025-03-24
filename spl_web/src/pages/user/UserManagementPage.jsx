import { useUser } from "../../context/UserContext";
import { useState } from "react";
import UserTable from "./components/UserTable";
import UserBlockModal from "./components/UserBlockModal";
import UserEditModal from "./components/UserEditModal";
import UserDeleteConfirm from "./components/UserDeleteConfirm";

const UserManagementPage = () => {
  const {
    users,
    deleteUser,
    blockUser,
    unblockUser,
    updateUser,
    removeUser,
    updateUserLocal,
  } = useUser();

  const [selectedUser, setSelectedUser] = useState(null);
  const [showBlockModal, setShowBlockModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [blockingUntil, setBlockingUntil] = useState("");

  const handleDelete = (user) => {
    setSelectedUser(user);
    setShowDeleteModal(true);
  };

  const confirmDelete = async () => {
    await deleteUser(selectedUser.id);
    removeUser(selectedUser.id);
    setShowDeleteModal(false);
  };

  const handleBlock = (user) => {
    setSelectedUser(user);
    setBlockingUntil("");
    setShowBlockModal(true);
  };

  const confirmBlock = async () => {
    if (!blockingUntil) return alert("Isi tanggal block!");
    await blockUser(selectedUser.id, blockingUntil);
    updateUserLocal(selectedUser.id, { blocked_until: blockingUntil });
    setBlockingUntil("");
    setShowBlockModal(false);
  };

  const handleUnblock = async (user) => {
    await unblockUser(user.id);
    updateUserLocal(user.id, { blocked_until: null });
  };

  const handleEdit = (user) => {
    setSelectedUser(user);
    setShowEditModal(true);
  };

  const confirmEdit = async (id, newData) => {
    await updateUser(id, newData);
    updateUserLocal(id, newData);
    setShowEditModal(false);
  };

  return (
    <div>
      <UserTable
        users={users}
        onDelete={handleDelete}
        onBlock={handleBlock}
        onUnblock={handleUnblock}
        onEdit={handleEdit}
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

      <UserDeleteConfirm
        show={showDeleteModal}
        onHide={() => setShowDeleteModal(false)}
        onConfirm={confirmDelete}
      />
    </div>
  );
};

export default UserManagementPage;
