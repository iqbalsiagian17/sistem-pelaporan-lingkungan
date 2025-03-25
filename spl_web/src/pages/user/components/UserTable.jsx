import { useState, useEffect } from "react";
import CustomPagination from "../../../components/common/CustomPagination";

import {
  Dropdown,
  Table,
  Card,
  Form,
  Row,
  Col,
  InputGroup,
  Button,
  Badge,
} from "react-bootstrap";


const UserTable = ({ users, onDelete, onBlock, onUnblock, onEdit }) => {
  const [searchQuery, setSearchQuery] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const usersPerPage = 10;

  // Filter user berdasarkan search
  const filteredUsers = users.filter((user) =>
    user.username.toLowerCase().includes(searchQuery.toLowerCase())
  );

  // Pagination logic
  const indexOfLastUser = currentPage * usersPerPage;
  const indexOfFirstUser = indexOfLastUser - usersPerPage;
  const currentUsers = filteredUsers.slice(indexOfFirstUser, indexOfLastUser);
  const totalPages = Math.ceil(filteredUsers.length / usersPerPage);

  const paginate = (pageNumber) => setCurrentPage(pageNumber);

  // Reset ke halaman 1 saat pencarian berubah
  useEffect(() => {
    setCurrentPage(1);
  }, [searchQuery]);

  return (
    <Card className="shadow-sm border-0">
      <Card.Header className="fw-bold text-primary bg-light">
        <Row className="align-items-center g-2">
          <Col xs={12} md={6} className="text-center text-md-start">
            <h5 className="mb-0">👥 Daftar Pengguna</h5>
          </Col>

          <Col xs={12} md={6}>
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
              >
                ❌
              </Button>
            </InputGroup>
          </Col>
        </Row>
      </Card.Header>

      <div className="table-responsive">
        <Table hover className="align-middle">
          <thead className="bg-light">
            <tr>
              <th>#</th>
              <th>Username</th>
              <th>Email</th>
              <th>No HP</th>
              <th>Role</th>
              <th>Jenis Akun</th> {/* Kolom baru */}
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
        <td>{user.email}</td>
        <td>{user.phone_number}</td>
        <td>
          <Badge bg={user.type === 1 ? "primary" : "success"}>
            {user.type === 1 ? "Admin" : "User"}
          </Badge>
        </td>
        <td>
          <Badge bg={user.auth_provider === "google" ? "danger" : "secondary"}>
            {user.auth_provider === "google" ? "Google" : "manual"}
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
              <button className="dropdown-item" onClick={() => onEdit(user)}>
                <i className="icon-base bx bx-edit-alt me-1"></i> Edit
              </button>
              <button className="dropdown-item" onClick={() => onDelete(user)}>
                <i className="icon-base bx bx-trash me-1"></i> Delete
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
