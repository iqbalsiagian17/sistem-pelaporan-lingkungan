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
  Spinner,
} from "react-bootstrap";

const UserTable = ({
  users,
  isLoading = false,
  onDelete,
  onBlock,
  onUnblock,
  onEdit,
  onChangePassword,
  onDetail,
}) => {
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
          <Col xs={12} md={6} className="mb-2 mb-md-0 text-center text-md-start">
            <h5 className="mb-0 text-primary fw-bold">Daftar Pengguna</h5>
          </Col>
          <Col xs={12} md={6}>
            <InputGroup className="shadow-sm">
              <Form.Control
                type="text"
                placeholder="Cari berdasarkan username..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
              />
              <Button
                variant="outline-secondary"
                onClick={() => setSearchQuery("")}
                title="Hapus Pencarian"
              >
                <i className="bx bx-x" />
              </Button>
            </InputGroup>
          </Col>
        </Row>
      </Card.Header>

      <div className="table-responsive">
        <Table hover className="align-middle mb-0">
          <thead className="table-light">
            <tr>
              <th>#</th>
              <th>Username</th>
              <th>Email</th>
              <th>No HP</th>
              <th>Role</th>
              <th>Jenis Akun</th>
              <th>Status</th>
              <th>Aksi</th>
            </tr>
          </thead>
          <tbody>
            {isLoading ? (
              <tr>
                <td colSpan="8" className="text-center py-5">
                  <Spinner animation="border" variant="primary" />
                  <div className="text-muted mt-2">Memuat data pengguna...</div>
                </td>
              </tr>
            ) : currentUsers.length > 0 ? (
              currentUsers.map((user, index) => (
                <tr key={user.id}>
                  <td>{indexOfFirstUser + index + 1}</td>
                  <td className="d-flex align-items-center">
                    <img
                      src={
                        user.profile_picture
                          ? `https://baligebersih.site/${user.profile_picture}`
                          : `https://ui-avatars.com/api/?name=${encodeURIComponent(user.username)}&background=3f51b5&color=fff`
                      }
                      alt={`Avatar ${user.username}`}
                      className="rounded-circle me-2"
                      width="36"
                      height="36"
                      style={{ objectFit: "cover" }}
                      onError={(e) => {
                        e.target.src = `https://ui-avatars.com/api/?name=${encodeURIComponent(user.username)}&background=3f51b5&color=fff`;
                      }}
                    />
                    {user.username}
                  </td>
                  <td>{user.email}</td>
                  <td>{user.phone_number}</td>
                  <td>
                    <Badge bg={user.type === 1 ? "primary" : "success"}>
                      {user.type === 1 ? "Admin" : "User"}
                    </Badge>
                  </td>
                  <td>
                    <Badge bg={`label-${user.auth_provider === "google" ? "danger" : "secondary"}`}>
                      {user.auth_provider === "google" ? "Google" : "Manual"}
                    </Badge>
                  </td>
                  <td>
                    <Badge bg={user.blocked_until ? "danger" : "success"}>
                      {user.blocked_until
                        ? `Sampai ${new Date(user.blocked_until).toLocaleDateString("id-ID")}`
                        : "Aktif"}
                    </Badge>
                  </td>
                  <td>
                    <div className="dropdown">
                      <button
                        type="button"
                        className="btn p-0 dropdown-toggle hide-arrow"
                        data-bs-toggle="dropdown"
                      >
                        <i className="bx bx-dots-vertical-rounded" />
                      </button>
                      <div className="dropdown-menu dropdown-menu-end">
                        <button className="dropdown-item" onClick={() => onDetail(user.id)}>
                          <i className="bx bx-info-circle me-1" /> Detail
                        </button>
                        <button className="dropdown-item" onClick={() => onEdit(user)}>
                          <i className="bx bx-edit-alt me-1" /> Edit
                        </button>
                        <button className="dropdown-item" onClick={() => onChangePassword(user)}>
                          <i className="bx bx-key me-1" /> Ganti Password
                        </button>
                        <button className="dropdown-item text-danger" onClick={() => onDelete(user)}>
                          <i className="bx bx-trash me-1" /> Hapus
                        </button>
                        {user.blocked_until ? (
                          <button className="dropdown-item" onClick={() => onUnblock(user)}>
                            <i className="bx bx-check-circle me-1" /> Unblock
                          </button>
                        ) : (
                          <button className="dropdown-item" onClick={() => onBlock(user)}>
                            <i className="bx bx-block me-1" /> Block
                          </button>
                        )}
                      </div>
                    </div>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td colSpan="8" className="text-center text-muted py-5">
                  Tidak ada pengguna ditemukan.
                </td>
              </tr>
            )}
          </tbody>
        </Table>
      </div>

      {!isLoading && filteredUsers.length > usersPerPage && (
        <div className="d-flex justify-content-center my-3">
          <CustomPagination
            currentPage={currentPage}
            totalPages={totalPages}
            onPageChange={paginate}
          />
        </div>
      )}
    </Card>
  );
};

export default UserTable;
