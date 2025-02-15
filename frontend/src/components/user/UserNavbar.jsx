import { useEffect, useState, useRef } from "react";
import { Link } from "react-router-dom";
import LoginModal from "../auth/LoginModal";
import "bootstrap/dist/css/bootstrap.min.css";
import "bootstrap-icons/font/bootstrap-icons.css";
import "bootstrap/dist/js/bootstrap.bundle.min";
import { Collapse } from "bootstrap";

import "../../style/user/navbar.css"


const UserNavbar = () => {
    // State untuk menyimpan waktu
    const [currentDate, setCurrentDate] = useState("");
    const [wibTime, setWibTime] = useState("");
    const [utcTime, setUtcTime] = useState("");
    const [showModal, setShowModal] = useState(false);
    const [isNavbarOpen, setIsNavbarOpen] = useState(false); // State untuk navbar
    const navbarRef = useRef(null);
    
    // Fungsi untuk menutup navbar saat menu diklik
    const closeNavbar = () => {
        setIsNavbarOpen(false);
    };

    // Fungsi untuk memperbarui waktu setiap detik
    useEffect(() => {
        const updateTime = () => {
            const now = new Date();

            // Format tanggal dalam bahasa Indonesia
            const options = { weekday: "long", day: "2-digit", month: "long", year: "numeric" };
            setCurrentDate(now.toLocaleDateString("id-ID", options).toUpperCase());

            // Format waktu WIB
            setWibTime(
                new Intl.DateTimeFormat("id-ID", {
                    hour: "2-digit",
                    minute: "2-digit",
                    second: "2-digit",
                    timeZone: "Asia/Jakarta",
                }).format(now) + " WIB"
            );

            // Format waktu UTC
            setUtcTime(
                new Intl.DateTimeFormat("en-GB", {
                    hour: "2-digit",
                    minute: "2-digit",
                    second: "2-digit",
                    timeZone: "UTC",
                }).format(now) + " UTC"
            );
        };

        // Jalankan pertama kali dan update setiap detik
        updateTime();
        const interval = setInterval(updateTime, 1000);
        return () => clearInterval(interval);
    }, []);


    
    return (
        <>
            {/* Topbar */}
            <div className="bg-light py-2">
                <div className="container fw-bold d-flex flex-wrap justify-content-between text-center text-md-start">
                    {/* Tanggal */}
                    <span>{currentDate}</span>

                    {/* Tombol untuk mode mobile */}
                    <button className="btn btn-sm btn-outline-success d-md-none" type="button" data-bs-toggle="collapse" data-bs-target="#timeCollapse">
                        Lihat Waktu ⌛
                    </button>

                    {/* Waktu WIB dan UTC */}
                    <span className="collapse d-md-block mt-2 mt-md-0" id="timeCollapse">
                        STANDAR WAKTU INDONESIA 
                        <span className="text-success"> {wibTime} </span> / 
                        <span className="text-success"> {utcTime} </span>
                    </span>
                </div>
            </div>

            {/* Navbar */}
            <nav className="navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top">
                <div className="container">
                    {/* Logo dan Nama DLH */}
                    <Link className="navbar-brand d-flex align-items-center" to="/">
                        <img
                            src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Seal_of_Toba_Regency_%282020%29.svg/1200px-Seal_of_Toba_Regency_%282020%29.svg.png"
                            alt="DLH Logo"
                            className="me-2"
                            height="50"
                        />
                        <div className="d-flex flex-column text-smalles">
                            <span className="fw-bold text-dark">DINAS LINGKUNGAN HIDUP</span>
                            <span className="fw-bold text-dark">TOBA</span>
                        </div>
                    </Link>

                    <button onClick={() => setShowModal(true)} className="btn btn-custom fw-bold d-block d-lg-none" style={{ width: "100px" }}>
                        Masuk
                    </button>

                    {/* Tombol Toggle Navbar */}
                    <button
                        className="navbar-toggler p-0 border-0"
                        type="button"
                        onClick={() => setIsNavbarOpen(!isNavbarOpen)} // Toggle navbar
                    >
                        <span className="navbar-toggler-icon"></span>
                    </button>

                    <div className={`collapse navbar-collapse ${isNavbarOpen ? "show" : ""}`} id="navbarNav">
                        <ul className="navbar-nav mx-auto gap-lg-3 gap-2">
                            <li className="nav-item fw-bold">
                                <Link className="nav-link active" to="/tentang" onClick={closeNavbar}>
                                    Tentang !
                                </Link>
                            </li>
                            <li className="nav-item fw-bold">
                                <Link className="nav-link" to="/diskusi" onClick={closeNavbar}>
                                    Diskusi
                                </Link>
                            </li>
                            <li className="nav-item fw-bold">
                                <Link className="nav-link" to="/pengumuman" onClick={closeNavbar}>
                                    Pengumuman
                                </Link>
                            </li>
                        </ul>
                    </div>

                    <button onClick={() => setShowModal(true)} className="btn btn-custom fw-bold d-none d-lg-block" style={{ width: "100px" }}>
                        Masuk
                    </button>
                </div>
            </nav>

            <LoginModal show={showModal} handleClose={() => setShowModal(false)} />
        </>
    );
};

export default UserNavbar;
