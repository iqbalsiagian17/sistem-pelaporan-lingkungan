import React, { createContext, useContext, useEffect, useState } from "react";
import {
  fetchAdminPosts,
  fetchAdminPostById,
  updateAdminPost,
  createAdminPost,
  createAdminComment,
  updateAdminComment,
  deleteAdminPost,
  deleteAdminComment,
  togglePinPost,
} from "../services/postService";

const PostContext = createContext();
export const usePost = () => useContext(PostContext);

export const PostProvider = ({ children }) => {
  const [posts, setPosts] = useState([]);

  useEffect(() => {
    loadPosts();
  }, []);

  const loadPosts = async () => {
    try {
      const data = await fetchAdminPosts();
      setPosts(data);
    } catch (err) {
      console.error("Gagal memuat post:", err.message);
    }
  };

  const addPost = async (formData) => {
    const newPost = await createAdminPost(formData);
    setPosts((prev) => [newPost, ...prev]);
  };

  const editPost = async (id, formData) => {
    const updated = await updateAdminPost(id, formData);
    setPosts((prev) =>
      prev.map((post) => (post.id === id ? { ...post, ...updated } : post))
    );
  };

  const addComment = async (data) => {
    return await createAdminComment(data);
  };

  const editComment = async (commentId, newContent) => {
    const updated = await updateAdminComment(commentId, { content: newContent });
    setPosts((prev) =>
      prev.map((post) => ({
        ...post,
        comments: post.comments.map((comment) =>
          comment.id === commentId ? { ...comment, ...updated } : comment
        ),
      }))
    );
  };
  

  const removePost = async (id) => {
    await deleteAdminPost(id);
    setPosts((prev) => prev.filter((p) => p.id !== id));
  };

  const removeComment = async (commentId) => {
    await deleteAdminComment(commentId);
    setPosts((prev) =>
      prev.map((post) => ({
        ...post,
        comments: post.comments.filter((c) => c.id !== commentId),
      }))
    );
  };

  const pinPost = async (id) => {
    const updated = await togglePinPost(id);
    setPosts((prev) =>
      prev.map((post) => (post.id === id ? { ...post, ...updated } : post))
    );
  };

  return (
    <PostContext.Provider
      value={{
        posts,
        loadPosts,
        addPost,
        editPost,
        editComment,
        addComment,
        removePost,
        removeComment,
        pinPost,
      }}
    >
      {children}
    </PostContext.Provider>
  );
};
