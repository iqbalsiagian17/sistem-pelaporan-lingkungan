import { fetchWithAuth } from "../utils/fetchWithAuth";

const BASE_URL = "http://localhost:3000/api/admin/users";

export const getAllUsers = async () => {
  const response = await fetchWithAuth(BASE_URL);
  const data = await response.json();
  return data.users;
};

export const getUserById = async (id) => {
  const response = await fetchWithAuth(`${BASE_URL}/${id}`);
  const data = await response.json();
  return data.user;
};

export const updateUser = async (id, payload) => {
  const response = await fetchWithAuth(`${BASE_URL}/${id}`, {
    method: "PUT",
    body: JSON.stringify(payload)
  });
  return await response.json();
};

export const deleteUser = async (id) => {
  const response = await fetchWithAuth(`${BASE_URL}/${id}`, {
    method: "DELETE"
  });
  return await response.json();
};

export const blockUser = async (id, blocked_until) => {
  const response = await fetchWithAuth(`${BASE_URL}/block/${id}`, {
    method: "PUT",
    body: JSON.stringify({ blocked_until })
  });
  return await response.json();
};

export const unblockUser = async (id) => {
  const response = await fetchWithAuth(`${BASE_URL}/unblock/${id}`, {
    method: "PUT"
  });
  return await response.json();
};

export const changeUserPassword = async (id, newPassword) => {
  const response = await fetchWithAuth(`${BASE_URL}/change-password/${id}`, {
    method: "PUT",
    body: JSON.stringify({ newPassword })
  });
  return await response.json();
};

export const getUserDetails = async (id) => {
  const response = await fetchWithAuth(`${BASE_URL}/details/${id}`);
  const data = await response.json();
  return data;
};