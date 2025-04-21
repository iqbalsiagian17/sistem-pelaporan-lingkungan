const LatestUsersTable = ({ latestUsers }) => (
    <div className="card">
      <div className="card-header pb-2">
        <h5 className="mb-1">Pengguna Terbaru</h5>
        <small className="text-muted">5 akun pengguna terbaru</small>
      </div>
      <div className="table-responsive text-nowrap">
        <table className="table table-hover">
          <thead className="table-light">
            <tr>
              <th>Nama</th>
              <th>Email</th>
              <th>Jenis Akun</th>
              <th>Terdaftar</th>
            </tr>
          </thead>
          <tbody>
            {latestUsers.length === 0 ? (
              <tr>
                <td colSpan="4" className="text-center text-muted">Belum ada pengguna baru.</td>
              </tr>
            ) : (
              latestUsers.map((user, index) => (
                <tr key={index}>
                  <td className="fw-semibold">{user.username}</td>
                  <td>{user.email}</td>
                  <td><span className="badge bg-label-primary">{user.auth_provider || "-"}</span></td>
                  <td>{user.createdAt && !isNaN(new Date(user.createdAt)) ? new Date(user.createdAt).toLocaleString("id-ID") : "-"}</td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
  
  export default LatestUsersTable;
  