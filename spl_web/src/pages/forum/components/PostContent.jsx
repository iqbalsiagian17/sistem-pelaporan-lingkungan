import React from "react";

const PostContent = ({ content, images, onImageClick, totalLikes = 0, totalComments = 0 }) => {

  return (
    <div className="px-3 pb-2">
        <p className="text-dark mb-3 mt-2" style={{ lineHeight: "1.6", whiteSpace: "pre-line" }}>
        {content}
        </p>

      {images?.length > 0 && (
  <div className="mb-2 d-flex flex-wrap gap-2">
    {images.length === 1 && (
      <img
        src={`http://localhost:3000/${images[0].image}`}
        alt="Post Gambar"
        className="w-100 rounded"
        style={{ objectFit: "cover", maxHeight: "400px", cursor: "pointer" }}
        onClick={() => onImageClick(images, 0)}
      />
    )}

    {images.length === 2 && images.map((img, i) => (
      <div key={i} style={{ width: "calc(50% - 4px)" }}>
        <img
          src={`http://localhost:3000/${img.image}`}
          alt={`Gambar ${i + 1}`}
          className="w-100 rounded"
          style={{ aspectRatio: "4/3", objectFit: "cover", cursor: "pointer" }}
          onClick={() => onImageClick(images, i)}
        />
      </div>
    ))}

    {images.length === 3 && (
      <>
        <div style={{ width: "100%" }}>
          <img
            src={`http://localhost:3000/${images[0].image}`}
            alt="Gambar 1"
            className="w-100 rounded mb-2"
            style={{ aspectRatio: "16/9", objectFit: "cover", cursor: "pointer" }}
            onClick={() => onImageClick(images, 0)}
          />
        </div>
        {images.slice(1).map((img, i) => (
          <div key={i + 1} style={{ width: "calc(50% - 4px)" }}>
            <img
              src={`http://localhost:3000/${img.image}`}
              alt={`Gambar ${i + 2}`}
              className="w-100 rounded"
              style={{ aspectRatio: "4/3", objectFit: "cover", cursor: "pointer" }}
              onClick={() => onImageClick(images, i + 1)}
            />
          </div>
        ))}
      </>
    )}

    {images.length >= 4 && images.map((img, i) => {
  if (i >= 4) return null; // hanya tampilkan 4 gambar pertama

  const isLastVisible = i === 3;
  const remainingCount = images.length - 4;

  return (
    <div key={i} style={{ width: "calc(50% - 4px)", position: "relative" }}>
      <img
        src={`http://localhost:3000/${img.image}`}
        alt={`Gambar ${i + 1}`}
        className="w-100 rounded"
        style={{ aspectRatio: "4/3", objectFit: "cover", cursor: "pointer" }}
        onClick={() => onImageClick(images, i)}
      />
      {isLastVisible && remainingCount > 0 && (
        <div
          className="position-absolute top-0 start-0 w-100 h-100 d-flex justify-content-center align-items-center bg-dark bg-opacity-50 text-white fs-4 fw-bold rounded"
          style={{ cursor: "pointer" }}
          onClick={() => onImageClick(images, i)}
        >
          +{remainingCount}
        </div>
      )}
    </div>
  );
})}

  </div>
)}


      <div className="d-flex justify-content-between align-items-center small text-muted mt-2">
  <div className="d-flex align-items-center gap-2">
    <i className="bi bi-hand-thumbs-up-fill text-primary"></i>
    <span>{totalLikes} suka</span>
  </div>
  <div className="d-flex align-items-center gap-2">
    <i className="bi bi-chat-left-text"></i>
    <span>{totalComments} komentar</span>
  </div>
</div>
    </div>
  );
};

export default PostContent;
