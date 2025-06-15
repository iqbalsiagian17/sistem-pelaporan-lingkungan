import { Card, Badge } from "react-bootstrap";
import AvatarCircle from "./AvatarCircle";
import { formatPostDate } from "../../../utils/formatDate";

const AdminProfileCard = ({ profile }) => {
  const { lastPostData } = profile;

  return (
    <Card className="mb-3 shadow-sm border-0 overflow-hidden">
      {/* Header background dengan avatar */}
      <div style={{ height: 80, background: "#d0dde5", position: "relative" }}>
        <div
          style={{
            width: 96,
            height: 96,
            borderRadius: "50%",
            backgroundColor: "#fff",
            position: "absolute",
            bottom: -48,
            left: "50%",
            transform: "translateX(-50%)",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            boxShadow: "0 0 0 3px #fff",
          }}
        >
          <AvatarCircle
            username={profile.username}
            profile_picture={profile.profile_picture}
            size={88}
            fontSize={28}
          />
        </div>
      </div>

      <Card.Body className="pt-5 text-center">
        {/* Nama dan jabatan */}
        <h5 className="fw-bold mb-1">{profile.username}</h5>
        <small className="text-muted mb-2 d-block">Administrator</small>
        <hr />

        {/* Statistik */}
        <ul className="list-unstyled text-start small px-3 mt-3">
          <li className="mb-2 d-flex justify-content-between">
            <span>Total Postingan</span>
            <strong>{profile.totalPosts}</strong>
          </li>
          <li className="d-flex justify-content-between">
            <span>Total Like</span>
            <strong>{profile.totalLikes}</strong>
          </li>
        </ul>

        {/* Postingan terakhir */}
        <div className="text-start px-3 mt-4">
          <h6 className="fw-semibold mb-2">Postingan Terakhir</h6>

          {lastPostData ? (
            <div
                className="d-block mb-2 p-1 rounded"
                style={{
                fontSize: "14px",
                transition: "background-color 0.2s",
                }}
                onMouseEnter={(e) => (e.currentTarget.style.backgroundColor = "#f8f9fa")}
                onMouseLeave={(e) => (e.currentTarget.style.backgroundColor = "transparent")}
            >
                <div className="fw-medium text-truncate">
                {lastPostData.content.length > 60
                    ? lastPostData.content.slice(0, 57) + "..."
                    : lastPostData.content}
                </div>
                <div className="text-muted small">
                {formatPostDate(lastPostData.createdAt)} • {lastPostData.likes} Like
                </div>
            </div>
            ) : (
            <p className="text-muted small"><em>Belum ada postingan</em></p>
            )}
        </div>
      </Card.Body>
    </Card>
  );
};

export default AdminProfileCard;
