import { Card } from "react-bootstrap";
import AvatarCircle from "./AvatarCircle"; // sesuaikan path bila perlu
import { formatPostDate } from "../../../utils/formatDate"; // sesuaikan path bila perlu

const ForumStatsCard = ({ totalPosts, postsWithImages, topPosts = [], totalComments = 0,totalPinnedPosts = 0, }) => {
  return (
    <Card className="mb-3 shadow-sm border-0 overflow-hidden">
      {/* Header Background */}
      <Card.Body className="pt-4 text-center">
        {/* Judul */}
        <h5 className="fw-bold mb-1">Statistik Forum</h5>
        <hr />

        {/* Statistik Umum */}
        <ul className="list-unstyled text-start small px-3 mt-3">
          <li className="mb-2 d-flex align-items-center">
            Total Postingan <strong className="ms-auto">{totalPosts}</strong>
          </li>
          <li className="mb-2 d-flex align-items-center">
            Postingan Dengan Gambar <strong className="ms-auto">{postsWithImages}</strong>
          </li>
          <li className="mb-2 d-flex align-items-center">
            Postingan Terpin <strong className="ms-auto">{totalPinnedPosts}</strong>
          </li>
          <li className="d-flex align-items-center">
            Komentar <strong className="ms-auto">{totalComments}</strong>
          </li>
        </ul>

        {/* Top 5 Postingan Terpopuler */}
      <div className="text-start px-3 mt-4">
        <h6 className="fw-semibold mb-3">Postingan Terpopuler</h6>

        {topPosts.length > 0 ? (
          <>
            {topPosts.slice(0, 10).map((post) => (
              <a
                key={post.id}
                href={`/forum#post-${post.id}`}
                className="text-decoration-none text-reset d-block mb-2 p-1 rounded"
                style={{
                  fontSize: "14px",
                  transition: "background-color 0.2s",
                }}
                onMouseEnter={(e) => (e.currentTarget.style.backgroundColor = "#f8f9fa")}
                onMouseLeave={(e) => (e.currentTarget.style.backgroundColor = "transparent")}
              >

                <div className="fw-medium text-truncate">
                  {post.content.length > 60 ? post.content.slice(0, 57) + "..." : post.content}
                </div>
                <div className="text-muted small">
                  {formatPostDate(post.createdAt)} • {post.total_likes} Like
                </div>
              </a>
            ))}
          </>
        ) : (
          <p className="text-muted small"><em>Tidak ada postingan populer</em></p>
        )}
      </div>

      </Card.Body>
    </Card>
  );
};

export default ForumStatsCard;
