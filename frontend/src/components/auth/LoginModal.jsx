import { useRef } from "react";
import { Modal, Button } from "bootstrap";
import { Link } from "react-router-dom";

import "../../style/auth/login-modal.css";

const LoginModal = ({ show, handleClose }) => {
    const modalRef = useRef();

    // Tutup modal saat klik tombol "X" atau area luar modal
    const closeModal = () => {
        const modal = Modal.getInstance(modalRef.current);
        if (modal) modal.hide();
        handleClose();
    };

    return (
        <div className={`modal fade ${show ? "show d-block" : ""}`} tabIndex="-1" ref={modalRef} style={{ backgroundColor: show ? "rgba(0,0,0,0.5)" : "transparent" }}>
            <div className="modal-dialog modal-dialog-centered">
                <div className="modal-content p-4">
                    <div className="modal-header">
                        <h2 className="modal-title fw-bold mx-auto">MASUK</h2>
                        <button type="button" className="btn-close position-absolute end-0 me-3" onClick={closeModal}></button>
                    </div>
                    <div className="modal-body">
                        <div className="divider"><span>Masuk Dengan Email Anda</span></div>
                        <form>
                            <div className="mb-3">
                                <label className="form-label">Email</label>
                                <input type="email" className="form-control" />
                            </div>
                            <div className="mb-3">
                                <label className="form-label">Password</label>
                                <input type="password" className="form-control" />
                            </div>
                            <div className="text-end mb-3">
                                <a href="#" className="text-primary">Lupa Password?</a>
                            </div>
                            <button type="submit" className="btn btn-dark w-100 mb-3">MASUK</button>
                        </form>
                        <div className="divider"><span>Masuk Dengan Akun Google</span></div>
                        <button className="btn btn-light w-100 border py-2 mt-3">
                            <img src="https://img.icons8.com/color/48/000000/google-logo.png" alt="Google" style={{ width: "20px", marginRight: "4px" }} /> 
                            <span className="fw-bold">Google</span>
                        </button>
                    </div>
                    <div className="modal-footer border-0 justify-content-center">
                        <p className="mb-0">Anda belum memiliki akun? <Link to="/register" className="fw-bold" style={{ textDecoration: "none" }}>DAFTAR SEKARANG</Link></p>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default LoginModal;
