// components/AvatarCircle.jsx
import React from "react";

const AvatarCircle = ({ username = "A", size = 50, fontSize = 20 }) => {
  const initial = username?.charAt(0).toUpperCase() || "A";

  return (
    <div
      style={{
        width: size,
        height: size,
        borderRadius: "50%",
        backgroundColor: "green",
        color: "white",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        fontSize,
      }}
    >
      {initial}
    </div>
  );
};

export default AvatarCircle;
