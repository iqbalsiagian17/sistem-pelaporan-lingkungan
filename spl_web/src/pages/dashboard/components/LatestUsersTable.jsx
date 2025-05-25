import React from "react";

const LatestUsersTable = ({ latestUsers }) => (
  <div className="card">
    <h5 className="card-header">Pengguna Terbaru</h5>
    <div className="table-responsive text-nowrap">
      <table className="table table-hover">
        <thead className="table-light">
          <tr>
            <th>Pengguna</th>
            <th>Email</th>
            <th>Jenis Akun</th>
            <th>Terdaftar</th>
          </tr>
        </thead>
        <tbody className="table-border-bottom-0">
          {latestUsers.length === 0 ? (
            <tr>
              <td colSpan="4" className="text-center text-muted">
                Belum ada pengguna baru.
              </td>
            </tr>
          ) : (
            latestUsers.map((user, index) => (
              <tr key={index}>
                <td className="d-flex align-items-center">
                  <img
                    src={
                      user.profile_picture
                        ? `https://baligebersih.site/${user.profile_picture}`
                        : `https://ui-avatars.com/api/?name=${encodeURIComponent(user.username)}&background=3f51b5&color=fff`
                    }
                    alt={`Avatar ${user.username}`}
                    className="rounded-circle me-2"
                    width="32"
                    height="32"
                    style={{ objectFit: "cover" }}
                    onError={(e) => {
                      e.target.src = `https://ui-avatars.com/api/?name=${encodeURIComponent(user.username)}&background=3f51b5&color=fff`;
                    }}
                  />
                  {user.username}
                </td>
                <td>{user.email}</td>
                <td>
                  <span className="badge bg-label-primary text-uppercase">
                    {user.auth_provider || "manual"}
                  </span>
                </td>
                <td>
                  {user.createdAt && !isNaN(new Date(user.createdAt))
                    ? new Date(user.createdAt).toLocaleString("id-ID")
                    : "-"}
                </td>
              </tr>
            ))
          )}
        </tbody>
      </table>
    </div>
  </div>
);

export default LatestUsersTable;
