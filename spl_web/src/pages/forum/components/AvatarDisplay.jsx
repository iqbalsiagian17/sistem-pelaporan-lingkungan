import React, { useState } from "react";
import AvatarCircle from "./AvatarCircle";

const AvatarDisplay = ({ username = "A", profile_picture = "", size = 48, fontSize = 18 }) => {
  const [imageError, setImageError] = useState(false);
  const imageUrl = profile_picture ? `http://localhost:3000/${profile_picture}` : null;

  if (!imageUrl || imageError) {
    return <AvatarCircle username={username} size={size} fontSize={fontSize} />;
  }

  return (
    <img
      src={imageUrl}
      alt={`@${username}`}
      onError={() => setImageError(true)} // ⬅️ Fallback ke inisial jika gambar gagal
      style={{
        width: size,
        height: size,
        borderRadius: "50%",
        objectFit: "cover",
        backgroundColor: "#e9ecef",
        border: "1px solid #dee2e6",
      }}
    />
  );
};

export default AvatarDisplay;
