import { createContext, useContext, useEffect, useState } from "react";
import {
  getAllUsers,
  getUserById,
  updateUser,
  deleteUser,
  blockUser,
  unblockUser,
  changeUserPassword,
  getUserDetails
} from "../services/userService";

const UserContext = createContext();
export const useUser = () => useContext(UserContext);

export const UserProvider = ({ children }) => {
  const [users, setUsers] = useState([]);

  const fetchUsers = async () => {
    try {
      const data = await getAllUsers();
      setUsers(data);
    } catch (error) {
      console.error("Gagal fetch users:", error);
    }
  };

  const removeUser = (id) => setUsers((prev) => prev.filter((u) => u.id !== id));
  const updateUserLocal = (id, updatedData) => {
    setUsers((prev) => prev.map((u) => (u.id === id ? { ...u, ...updatedData } : u)));
  };

  useEffect(() => {
    fetchUsers();
  }, []);

  return (
    <UserContext.Provider
      value={{
        users,
        fetchUsers,
        getUserById,
        updateUser,
        deleteUser,
        blockUser,
        unblockUser,
        changeUserPassword,
        removeUser,
        updateUserLocal,
        getUserDetails
      }}
    >
      {children}
    </UserContext.Provider>
  );
};
