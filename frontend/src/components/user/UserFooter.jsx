import { useState } from "react";
import LoginModal from "../auth/LoginModal";

const UserFooter = () => {
    const [showModal, setShowModal] = useState(false);

    return (
        <>
            <footer className="py-3 mt-4 bg-dark text-white">
                <div className="container">
                    <ul className="nav justify-content-center border-bottom pb-3 mb-3 gap-3">
                        <li className="nav-item"><a href="/" className="nav-link px-2 text-white">Beranda</a></li>
                        <li className="nav-item"><a href="/profil" className="nav-link px-2 text-white">Profil</a></li>
                        <li className="nav-item"><a href="/berita" className="nav-link px-2 text-white">Berita</a></li>
                        <li className="nav-item"><a href="/pengumuman" className="nav-link px-2 text-white">Pengumuman</a></li>
                        {/* Tombol untuk membuka modal login */}
                        <li className="nav-item">
                            <button onClick={() => setShowModal(true)} className="nav-link px-2 text-white border-0 bg-transparent">
                                Masuk
                            </button>
                        </li>
                    </ul>
                    <p className="text-center">&copy; 2025 Dinas Lingkungan Hidup Toba</p>
                </div>
            </footer>

            {/* Modal Login (Diletakkan di luar footer agar tetap dirender) */}
            <LoginModal show={showModal} handleClose={() => setShowModal(false)} />
        </>
    );
};

export default UserFooter;
