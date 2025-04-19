import { useState, useEffect } from "react";
import CustomPagination from "../../../components/common/CustomPagination";
import {
  Table,
  Card,
  Form,
  Row,
  Col,
  InputGroup,
  Button,
  Badge,
} from "react-bootstrap";

const UserTable = ({ users, onDelete, onBlock, onUnblock, onEdit, onChangePassword, onDetail }) => {
  const [searchQuery, setSearchQuery] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const usersPerPage = 10;

  const filteredUsers = users.filter((user) =>
    user.username.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const indexOfLastUser = currentPage * usersPerPage;
  const indexOfFirstUser = indexOfLastUser - usersPerPage;
  const currentUsers = filteredUsers.slice(indexOfFirstUser, indexOfLastUser);
  const totalPages = Math.ceil(filteredUsers.length / usersPerPage);

  const paginate = (pageNumber) => setCurrentPage(pageNumber);

  useEffect(() => {
    setCurrentPage(1);
  }, [searchQuery]);

  return (
    <Card className="shadow-sm border-0">
      <Card.Header className="bg-light">
        <Row className="align-items-center">
          {/* 📋 Judul */}
          <Col xs={12} md={6} className="mb-2 mb-md-0 text-center text-md-start">
            <h5 className="mb-0 text-primary fw-bold">
               Daftar Pengguna
            </h5>
          </Col>

          {/* 🔍 Search + ❌ (tanpa Export) */}
          <Col xs={12} md={6} className="d-flex justify-content-md-end justify-content-center align-items-center">
            <div className="d-flex gap-2" style={{ maxWidth: "300px", width: "100%" }}>
              <InputGroup>
                <Form.Control
                  type="text"
                  placeholder="Cari berdasarkan username..."
                  value={searchQuery}
                  className="border-0 shadow-sm"
                  onChange={(e) => setSearchQuery(e.target.value)}
                />
                <Button
                  variant="outline-secondary"
                  className="border-0 shadow-sm"
                  onClick={() => setSearchQuery("")}
                  title="Hapus Pencarian"
                >
                  <i className="bx bx-x" style={{ fontSize: "18px" }}></i>
                </Button>
              </InputGroup>
            </div>
          </Col>
        </Row>
      </Card.Header>


      <div className="table-responsive">
        <Table hover className="align-middle">
          <thead className="bg-light">
            <tr>
              <th>#</th>
              <th>Username</th>
              <th>Profile</th>
              <th>Email</th>
              <th>No HP</th>
              <th>Role</th>
              <th>Jenis Akun</th>
              <th>Status Blokir</th>
              <th>Aksi</th>
            </tr>
          </thead>
          <tbody>
            {currentUsers.length > 0 ? (
              currentUsers.map((user, index) => (
                <tr key={user.id}>
                  <td>{indexOfFirstUser + index + 1}</td>
                  <td>{user.username}</td>
                  <td>
                    <img
                      src={
                        user.profile_picture
                          ? `http://localhost:3000/${user.profile_picture}`
                          : `https://ui-avatars.com/api/?name=${encodeURIComponent(user.username)}&background=66BB6A&color=fff`
                      }
                      alt={`Foto profil ${user.username}`}
                      className="rounded-circle"
                      style={{ width: "40px", height: "40px", objectFit: "cover" }}
                    />
                  </td>
                  <td>{user.email}</td>
                  <td>{user.phone_number}</td>
                  <td>
                    <Badge bg={user.type === 1 ? "primary" : "success"}>
                      {user.type === 1 ? "Admin" : "User"}
                    </Badge>
                  </td>
                  <td>
                    <Badge bg={user.auth_provider === "google" ? "danger" : "secondary"}>
                      {user.auth_provider === "google" ? "Google" : "Manual"}
                    </Badge>
                  </td>
                  <td>
                    {user.blocked_until ? (
                      <Badge bg="danger">
                        Sampai {new Date(user.blocked_until).toLocaleDateString("id-ID")}
                      </Badge>
                    ) : (
                      <Badge bg="success">Aktif</Badge>
                    )}
                  </td>
                  <td>
                    <div className="dropdown">
                      <button
                        type="button"
                        className="btn p-0 dropdown-toggle hide-arrow"
                        data-bs-toggle="dropdown"
                      >
                        <i className="icon-base bx bx-dots-vertical-rounded"></i>
                      </button>
                      <div className="dropdown-menu">
                        <button className="dropdown-item" onClick={() => onDetail(user.id)}>
                          <i className="icon-base bx bx-info-circle me-1"></i> Detail
                        </button>

                        <button className="dropdown-item" onClick={() => onEdit(user)}>
                          <i className="icon-base bx bx-edit-alt me-1"></i> Edit
                        </button>
                        <button className="dropdown-item" onClick={() => onDelete(user)}>
                          <i className="icon-base bx bx-trash me-1"></i> Delete
                        </button>
                        <button className="dropdown-item" onClick={() => onChangePassword(user)}>
                          <i className="icon-base bx bx-key me-1"></i> Ganti Password
                        </button>
                        {user.blocked_until ? (
                          <button className="dropdown-item" onClick={() => onUnblock(user)}>
                            <i className="icon-base bx bx-check-circle me-1"></i> Unblock
                          </button>
                        ) : (
                          <button className="dropdown-item" onClick={() => onBlock(user)}>
                            <i className="icon-base bx bx-block me-1"></i> Block
                          </button>
                        )}
                      </div>
                    </div>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td colSpan="8" className="text-center text-muted">
                  Tidak ada pengguna ditemukan.
                </td>
              </tr>
            )}
          </tbody>
        </Table>

        {filteredUsers.length > usersPerPage && (
          <div className="d-flex justify-content-center my-3">
            <CustomPagination
              currentPage={currentPage}
              totalPages={totalPages}
              onPageChange={paginate}
            />
          </div>
        )}
      </div>
    </Card>
  );
};

export default UserTable;
