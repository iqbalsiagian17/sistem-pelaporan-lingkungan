import { Link } from "react-router-dom";

function Navbar() {
    return (
        <nav style={{ padding: "10px", background: "#007bff", color: "white" }}>
            <ul style={{ listStyle: "none", display: "flex", gap: "15px" }}>
                <li><Link to="/" style={{ color: "white", textDecoration: "none" }}>Home</Link></li>
                <li><Link to="/reports" style={{ color: "white", textDecoration: "none" }}>Laporan</Link></li>
                <li><Link to="/maps/google" style={{ color: "white", textDecoration: "none" }}>Google Maps</Link></li>
                <li><Link to="/maps/openstreet" style={{ color: "white", textDecoration: "none" }}>OpenStreetMap</Link></li>
            </ul>
        </nav>
    );
}

export default Navbar; // Pastikan `export default Navbar` ada di akhir file
