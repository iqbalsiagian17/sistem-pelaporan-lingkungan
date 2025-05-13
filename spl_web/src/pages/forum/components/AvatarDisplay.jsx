// components/AvatarDisplay.jsx
import React from "react";
import AvatarCircle from "./AvatarCircle";

const AvatarDisplay = ({ username = "A", profile_picture = "", size = 50, fontSize = 20 }) => {
  const imageUrl = profile_picture ? `http://69.62.82.58:3000/${profile_picture}` : null;

  return imageUrl ? (
    <img
      src={imageUrl}
      alt={`@${username}`}
      style={{
        width: size,
        height: size,
        borderRadius: "50%",
        objectFit: "cover",
        backgroundColor: "#eaeaea",
      }}
    />
  ) : (
    <AvatarCircle username={username} size={size} fontSize={fontSize} />
  );
};

export default AvatarDisplay;
