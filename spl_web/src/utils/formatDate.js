// src/utils/dateUtils.js

export const formatPostDate = (timestamp) => {
  const now = new Date();
  const createdAt = new Date(timestamp);
  const diffMs = now - createdAt;
  const diffMinutes = Math.floor(diffMs / (1000 * 60));
  const diffHours = Math.floor(diffMs / (1000 * 60 * 60));

  if (diffMinutes < 1) return "Baru saja";
  if (diffMinutes < 60) return `${diffMinutes} menit yang lalu`;
  if (diffHours < 24) return `${diffHours} jam yang lalu`;

  const sameYear = now.getFullYear() === createdAt.getFullYear();
  return createdAt.toLocaleDateString("id-ID", {
    day: "2-digit",
    month: "short",
    ...(sameYear ? {} : { year: "numeric" }),
  });
};
