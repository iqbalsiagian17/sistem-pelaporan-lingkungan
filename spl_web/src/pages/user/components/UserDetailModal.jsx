import React, { useState } from "react";
import { Modal, Button, Table, Badge } from "react-bootstrap";

const UserDetailModal = ({ show, onHide, user }) => {
  
  const [showAllPosts, setShowAllPosts] = useState(false); 


  if (!user) return null;


  const { username, email, phone_number, type, auth_provider } = user.user || {};
  const posts = user.posts || [];
  const reports = user.reports || [];
  const likedReports = user.liked_reports || [];

  return (
    <Modal show={show} onHide={onHide} size="lg" centered scrollable>
      <Modal.Header closeButton className="bg-light border-bottom-0">
        <Modal.Title className="fw-semibold text-primary">
          👤 Detail Pengguna - {username}
        </Modal.Title>
      </Modal.Header>

      <Modal.Body className="px-4">
        {/* Informasi Umum */}
        <section className="mb-4">
          <h6 className="fw-bold text-secondary border-bottom pb-2">🧾 Informasi Umum</h6>
          <Table bordered size="sm" className="mt-3">
            <tbody>
              <tr>
                <th style={{ width: "30%" }}>Username</th>
                <td>{username}</td>
              </tr>
              <tr>
                <th style={{ width: "30%" }}>Email</th>
                <td>{email}</td>
              </tr>
              <tr>
                <th>No HP</th>
                <td>{phone_number || "-"}</td>
              </tr>
              <tr>
                <th>Role</th>
                <td>
                  <Badge bg={type === 1 ? "primary" : "success"}>
                    {type === 1 ? "Admin" : "User"}
                  </Badge>
                </td>
              </tr>
              <tr>
                <th>Jenis Akun</th>
                <td>
                  <Badge bg={auth_provider === "google" ? "danger" : "secondary"}>
                    {auth_provider}
                  </Badge>
                </td>
              </tr>
            </tbody>
          </Table>
        </section>


        {/* Postingan */}
        <section className="mb-4">
          <h6 className="fw-bold text-secondary border-bottom pb-2">📝 Postingan</h6>
          {posts.length > 0 ? (
            <>
              <div className="d-flex flex-column gap-3 mt-3">
                {(showAllPosts ? posts : posts.slice(0, 2)).map((post, index) => (
                  <div key={post.id} className="border rounded p-3 shadow-sm bg-light">
                    <div className="d-flex justify-content-between align-items-start mb-2">
                      <div className="fw-bold text-primary">#{index + 1}</div>
                      <Badge bg="secondary">{post.likes} Likes</Badge>
                    </div>
                    <p className="mb-2">{post.content}</p>

                    {post.images && post.images.length > 0 && (
                      <div className="d-flex flex-wrap gap-2">
                        {post.images.map((img) => (
                          <img
                            key={img.id}
                            src={`http://localhost:3000/${img.image}`}
                            alt="gambar postingan"
                            className="rounded"
                            style={{
                              width: "100px",
                              height: "100px",
                              objectFit: "cover",
                            }}
                          />
                        ))}
                      </div>
                    )}
                  </div>
                ))}
              </div>

              {posts.length > 2 && (
                <div className="text-center mt-3">
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
            <p className="text-muted fst-italic mt-2">Tidak ada postingan.</p>
          )}
        </section>



        {/* Laporan */}
        <section className="mb-4">
          <h6 className="fw-bold text-secondary border-bottom pb-2">📢 Laporan</h6>
          {reports.length > 0 ? (
            <Table size="sm" bordered hover className="mt-2">
              <thead className="table-light">
                <tr>
                  <th>#</th>
                  <th>No Laporan</th>
                  <th>Judul</th>
                  <th>Deskripsi</th>
                  <th>Status</th>
                  <th>Tanggal</th>
                  <th>Likes</th>
                </tr>
              </thead>
              <tbody>
                {reports.map((report, index) => (
                  <tr key={report.id}>
                    <td>{index + 1}</td>
                    <td>{report.report_number}</td>
                    <td>{report.title}</td>
                    <td>{report.description}</td>
                    <td>
                      <Badge bg="info" className="text-capitalize">
                        {report.status}
                      </Badge>
                    </td>
                    <td>{new Date(report.date).toLocaleDateString("id-ID")}</td>
                    <td>{report.likes}</td>
                  </tr>
                ))}
              </tbody>
            </Table>
          ) : (
            <p className="text-muted fst-italic">Tidak ada laporan.</p>
          )}
        </section>

        {/* Laporan yang Disukai */}
        <section>
          <h6 className="fw-bold text-secondary border-bottom pb-2">❤️ Laporan yang Disukai</h6>
          {likedReports.length > 0 ? (
            <Table size="sm" bordered hover className="mt-2">
              <thead className="table-light">
                <tr>
                  <th>#</th>
                  <th>Judul</th>
                  <th>Pelapor</th>
                  <th>Tanggal</th>
                </tr>
              </thead>
              <tbody>
                {likedReports.map((like, index) => (
                  <tr key={like.id}>
                    <td>{index + 1}</td>
                    <td>{like.report.title}</td>
                    <td>{like.report.user?.username || "Tidak diketahui"}</td>
                    <td>{new Date(like.report.date).toLocaleDateString("id-ID")}</td>
                  </tr>
                ))}
              </tbody>
            </Table>
          ) : (
            <p className="text-muted fst-italic">Belum menyukai laporan.</p>
          )}
        </section>
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
