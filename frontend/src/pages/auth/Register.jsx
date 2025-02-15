import { useState } from "react";
import { Link } from "react-router-dom";


import "../../style/auth/register.css";
import "bootstrap/dist/css/bootstrap.min.css";
import "bootstrap-icons/font/bootstrap-icons.css";
import "bootstrap/dist/js/bootstrap.bundle.min";

const Register = () => {
    const [formData, setFormData] = useState({
        fullName: "",
        username: "",
        email: "",
        password: "",
        confirmPassword: "",
        phone: "",
        birthDate: "",
        termsAccepted: false
    });

    // Handle perubahan input
    const handleChange = (e) => {
        const { name, value, type, checked } = e.target;
        setFormData({
            ...formData,
            [name]: type === "checkbox" ? checked : value
        });
    };

    // Handle Submit Form
    const handleSubmit = (e) => {
        e.preventDefault();
        if (!formData.termsAccepted) {
            alert("Anda harus menyetujui syarat dan ketentuan!");
            return;
        }
        console.log("Data yang dikirim:", formData);
        alert("Pendaftaran berhasil!");
    };

    return (
        <div className="container p-5">
            {/* Logo DLH */}
            <div className="d-flex flex-column justify-content-center align-items-center mb-5">
                <Link className="navbar-brand d-flex align-items-center" to="/">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Seal_of_Toba_Regency_%282020%29.svg/1200px-Seal_of_Toba_Regency_%282020%29.svg.png" alt="DLH Logo" className="me-2" height="50"/>
                    <div className="d-flex flex-column text-smalles text-start">
                        <span className="fw-bold text-dark">DINAS LINGKUNGAN HIDUP</span>
                        <span className="fw-bold text-dark">TOBA</span>
                    </div>
                </Link>
            </div>

            {/* Form Register */}
            <div className="row justify-content-center">
                <div className="col-md-7">
                    <div className="card shadow rounded-0 border-0 p-5 mt-5">
                        <h2 className="fw-bold text-center">DAFTAR</h2>

                        {/* Info Pendaftaran */}
                        <div className="alert alert-light border mt-3 mb-3">
                            <span className="fw-bold">Perhatikan cara Mendaftar Akun yang Baik dan Benar</span>
                            <button className="btn btn-light btn-sm float-end">❓</button>
                        </div>

                        {/* Login dengan Google */}
                        <div className="divider text-muted"><span>Gunakan Akun Media Sosial Anda</span></div>
                        <button className="btn google-btn mt-3 mb-3">
                            <img src="https://img.icons8.com/color/48/000000/google-logo.png" alt="Google"/>
                            <span>Google</span>
                        </button>

                        <div className="divider text-muted"><span>Atau</span></div>

                        {/* Formulir Register */}
                        <form onSubmit={handleSubmit}>
                            <div className="mb-3">
                                <label className="form-label">Nama Lengkap</label>
                                <input type="text" className="form-control" name="fullName" placeholder="Nama Lengkap" value={formData.fullName} onChange={handleChange} required/>
                            </div>

                            <div className="mb-3">
                                <label className="form-label">Username</label>
                                <input type="text" className="form-control" name="username" placeholder="Username" value={formData.username} onChange={handleChange} required/>
                            </div>

                            <div className="mb-3">
                                <label className="form-label">Email</label>
                                <input type="email" className="form-control" name="email" placeholder="lapor@contoh.com" value={formData.email} onChange={handleChange} required/>
                            </div>

                            <div className="mb-3">
                                <label className="form-label">Password</label>
                                <input type="password" className="form-control" name="password" placeholder="********" value={formData.password} onChange={handleChange} required/>
                            </div>

                            <div className="mb-3">
                                <label className="form-label">Konfirmasi Password</label>
                                <input type="password" className="form-control" name="confirmPassword" placeholder="********" value={formData.confirmPassword} onChange={handleChange} required/>
                            </div>

                            <div className="mb-3">
                                <label className="form-label">No. Telp Aktif</label>
                                <input type="text" className="form-control" name="phone" placeholder="Minimal 8 - 14 Angka" value={formData.phone} onChange={handleChange} required/>
                            </div>

                            <div className="mb-3">
                                <label className="form-label">Tanggal Lahir</label>
                                <input type="date" className="form-control" name="birthDate" value={formData.birthDate} onChange={handleChange} required/>
                            </div>

                            <div className="mb-3 form-check">
                                <input type="checkbox" className="form-check-input" name="termsAccepted" checked={formData.termsAccepted} onChange={handleChange} required/>
                                <label className="form-check-label">Saya telah membaca dan menyetujui <a href="#">Syarat dan Ketentuan</a></label>
                            </div>

                            <button type="submit" className="btn btn-dark w-100">DAFTAR</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Register;
