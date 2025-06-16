import React, { useState } from "react";
import { Modal, Button, Table, Badge, Tabs, Tab } from "react-bootstrap";
import { FaCheckCircle, FaTimesCircle } from "react-icons/fa";
import statusData from "../../../data/statusData.json";

const UserDetailModal = ({ show, onHide, user }) => {
  const [showAllPosts, setShowAllPosts] = useState(false);
  const [showAllReports, setShowAllReports] = useState(false);
  const [showAllLiked, setShowAllLiked] = useState(false);

  if (!user) return null;

  const {
    username,
    email,
    phone_number,
    type,
    auth_provider,
    blocked_until,
    createdAt,
    is_active,
    profile_picture,
    id: userId
  } = user.user || {};

  const posts = user.posts || [];
  const reports = user.reports || [];
  const likedReports = user.liked_reports || [];

  const formattedUserId = userId
    ? `${userId.toString().slice(0, 4)}••••${userId.toString().slice(-4)}`
    : "—";

  return (
    <Modal show={show} onHide={onHide} size="lg" centered scrollable>
      <Modal.Header closeButton className="bg-light border-bottom-0">
        <Modal.Title className="fw-semibold text-primary">
          Detail Pengguna - {username}
        </Modal.Title>
      </Modal.Header>

      <Modal.Body className="px-4">
        {/* Profile Info */}
        <section className="mb-4">
          <div className="d-flex align-items-start flex-column flex-md-row gap-4">
            {/* Avatar */}
            <div className="text-center">
              <img
                src={
                  profile_picture
                    ? `http://localhost:3000/${profile_picture}`
                    : `https://ui-avatars.com/api/?name=${encodeURIComponent(username)}&background=198754&color=fff`
                }
                onError={(e) => {
                  e.target.onerror = null;
                  e.target.src = `https://ui-avatars.com/api/?name=${encodeURIComponent(username)}&background=198754&color=fff`;
                }}
                alt={`Avatar ${username}`}
                className="rounded-circle mb-2"
                style={{ width: 100, height: 100, objectFit: "cover" }}
              />
              <h6 className="fw-bold mb-0">{username || "Tanpa Nama"}</h6>
            </div>

            {/* Detail */}
            <div className="flex-grow-1">
              <div className="mb-3 small">
                <div className="d-flex justify-content-between flex-wrap">
                  <div className="mb-2">
                    <div className="text-muted">Email</div>
                    <div>{email}</div>
                  </div>
                  <div className="mb-2">
                    <div className="text-muted">User ID</div>
                    <div className="text-break">{formattedUserId}</div>
                  </div>
                </div>
              </div>

              <hr className="my-2" />

              <div className="row small">
                <div className="col-sm-6 mb-2">
                  <div className="text-muted">Mobile Phone</div>
                  <div>{phone_number || "–"}</div>
                </div>
                <div className="col-sm-6 mb-2">
                  <div className="text-muted">Username</div>
                  <div>{username || "–"}</div>
                </div>
                <div className="col-sm-6 mb-2">
                  <div className="text-muted">Role</div>
                  <Badge bg={type === 1 ? "primary" : "success"}>
                    {type === 1 ? "Admin" : "User"}
                  </Badge>
                </div>
                <div className="col-sm-6 mb-2">
                  <div className="text-muted">Jenis Akun</div>
                  <Badge bg={auth_provider === "google" ? "danger" : "secondary"}>
                    {auth_provider}
                  </Badge>
                </div>
                <div className="col-sm-6 mb-2">
                  <div className="text-muted">Status Aktif</div>
                  {blocked_until ? (
                    <span className="text-warning d-flex align-items-center gap-1">
                      <i className="bi bi-lock-fill"></i> Diblokir hingga{" "}
                      {new Date(blocked_until).toLocaleDateString("id-ID", {
                        day: "2-digit",
                        month: "long",
                        year: "numeric",
                      })}
                    </span>
                  ) : is_active ? (
                    <span className="text-success d-flex align-items-center gap-1">
                      <FaCheckCircle /> Aktif
                    </span>
                  ) : (
                    <span className="text-danger d-flex align-items-center gap-1">
                      <FaTimesCircle /> Tidak Aktif
                    </span>
                  )}
                </div>
                <div className="col-sm-6 mb-2">
                  <div className="text-muted">Tanggal Dibuat</div>
                  {createdAt
                    ? new Date(createdAt).toLocaleDateString("id-ID", {
                        day: "2-digit",
                        month: "long",
                        year: "numeric",
                      })
                    : "–"}
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* Tabs */}
        <Tabs defaultActiveKey="posts" className="mb-4 bg-light" fill>
          {/* Postingan */}
          <Tab eventKey="posts" title="Postingan">
            {posts.length > 0 ? (
            <>
              {(showAllPosts ? posts : posts.slice(0, 5)).map((post) => (
                <div
                  key={post.id}
                  className="text-reset d-block mb-3 p-2 rounded bg-white border shadow-sm"
                  style={{
                    fontSize: "14px",
                    transition: "background-color 0.2s",
                  }}
                  onMouseEnter={(e) => (e.currentTarget.style.backgroundColor = "#f8f9fa")}
                  onMouseLeave={(e) => (e.currentTarget.style.backgroundColor = "#ffffff")}
                >
                  {/* Konten teks */}
                  <div className="fw-medium text-truncate mb-1">
                    {post.content?.length > 100 ? post.content.slice(0, 97) + "..." : post.content}
                  </div>

                  {/* Gambar jika ada */}
                  {post.images?.length > 0 && (
                    <div className="d-flex flex-wrap gap-2 mb-1">
                      {post.images.map((img) => (
                        <img
                          key={img.id}
                          src={`http://localhost:3000/${img.image}`}
                          alt="gambar postingan"
                          className="rounded"
                          style={{
                            width: "60px",
                            height: "60px",
                            objectFit: "cover",
                            border: "1px solid #dee2e6",
                          }}
                        />
                      ))}
                    </div>
                  )}

                  {/* Metadata */}
                  <div className="text-muted small">
                    {new Date(post.createdAt).toLocaleDateString("id-ID")} • {post.total_likes} Like
                  </div>
                </div>
              ))}

              {/* Tombol Lihat Selengkapnya */}
              {posts.length > 5 && (
                <div className="text-center mt-2">
                  <button
                    className="btn btn-sm btn-outline-primary"
                    onClick={() => setShowAllPosts(!showAllPosts)}
                  >
                    {showAllPosts ? "Sembunyikan" : "Lihat Selengkapnya"}
                  </button>
                </div>
              )}
            </>
          ) : (
            <p className="text-muted small fst-italic mt-2">Tidak ada postingan.</p>
          )}

          </Tab>


          {/* Laporan */}
          <Tab eventKey="reports" title="Laporan">
            {reports.length > 0 ? (
              <>
                <div className="row mt-3 g-3">
                  {(showAllReports ? reports : reports.slice(0, 6)).map((report, index) => (
                    <div key={report.id} className="col-md-6">
                      <div className="border rounded shadow-sm p-3 bg-light h-100">
                        <div className="d-flex justify-content-between mb-2">
                          <span className="fw-bold text-primary">#{index + 1}</span>
                          <Badge
                            bg={statusData.statusMappings[report.status]?.color || "secondary"}
                            className="text-capitalize"
                          >
                            {statusData.statusMappings[report.status]?.label || report.status}
                          </Badge>
                        </div>
                        <h6 className="mb-1">{report.title}</h6>
                        <p className="small text-muted mb-2 text-wrap">
                          {report.description?.length > 100
                            ? report.description.slice(0, 97) + "..."
                            : report.description}
                        </p>
                        <div className="d-flex justify-content-between small text-muted">
                          <div>{new Date(report.date).toLocaleDateString("id-ID")}</div>
                          <div>{report.total_likes} Dukungan</div>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>

                {reports.length > 6 && (
                  <div className="text-center mt-3">
                    <button
                      className="btn btn-sm btn-outline-primary"
                      onClick={() => setShowAllReports(!showAllReports)}
                    >
                      {showAllReports ? "Sembunyikan" : "Lihat Selengkapnya"}
                    </button>
                  </div>
                )}
              </>
            ) : (
              <p className="text-muted fst-italic mt-2">Tidak ada laporan.</p>
            )}
          </Tab>


          {/* Disukai */}
          <Tab eventKey="liked" title="Laporan Disukai">
            {likedReports.length > 0 ? (
              <>
                <div className="row mt-3 g-3">
                  {(showAllLiked ? likedReports : likedReports.slice(0, 5)).map((like, index) => (
                    <div key={like.id} className="col-md-6">
                      <div className="border rounded shadow-sm p-3 bg-light h-100">
                        <div className="d-flex justify-content-between mb-2">
                          <span className="fw-bold text-primary">#{index + 1}</span>
                          <span className="badge bg-secondary">Disukai</span>
                        </div>
                        <h6 className="mb-1">{like?.title || "Tidak diketahui"}</h6>
                        <div className="small text-muted mb-1">
                          <strong>Pelapor:</strong> {like?.user?.username || "Tidak diketahui"}
                        </div>
                        <div className="small text-muted">
                          <strong>Tanggal:</strong>{" "}
                          {like?.date ? new Date(like.date).toLocaleDateString("id-ID") : "-"}
                        </div>
                      </div>
                    </div>
                  ))}
                </div>

                {/* Tombol Lihat Selengkapnya */}
                {likedReports.length > 5 && (
                  <div className="text-center mt-2">
                    <button
                      className="btn btn-sm btn-outline-primary"
                      onClick={() => setShowAllLiked(!showAllLiked)}
                    >
                      {showAllLiked ? "Sembunyikan" : "Lihat Selengkapnya"}
                    </button>
                  </div>
                )}
              </>
            ) : (
              <p className="text-muted fst-italic mt-2">Belum menyukai laporan.</p>
            )}
          </Tab>
        </Tabs>
      </Modal.Body>

      <Modal.Footer className="bg-light border-top-0">
        <Button variant="secondary" onClick={onHide}>
          Tutup
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default UserDetailModal;
