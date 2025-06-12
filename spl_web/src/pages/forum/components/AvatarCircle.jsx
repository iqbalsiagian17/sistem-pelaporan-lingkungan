import React from "react";

const AvatarCircle = ({ username = "A", profile_picture = "", size = 50, fontSize = 20 }) => {
  const initial = username?.charAt(0).toUpperCase() || "A";

  const avatarStyle = {
    width: size,
    height: size,
    borderRadius: "50%",
    backgroundColor: "#198754", // hijau Bootstrap
    color: "white",
    display: "flex",
    justifyContent: "center",
    alignItems: "center",
    fontSize,
    overflow: "hidden",
    flexShrink: 0,
  };

  if (profile_picture) {
    return (
      <img
        src={`http://localhost:3000/${profile_picture}`}
        alt={username}
        style={{
          ...avatarStyle,
          objectFit: "cover",
        }}
      />
    );
  }

  return <div style={avatarStyle}>{initial}</div>;
};

export default AvatarCircle;
