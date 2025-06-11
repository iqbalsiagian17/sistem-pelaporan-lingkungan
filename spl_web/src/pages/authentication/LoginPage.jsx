import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import './page-auth.css';
import { AuthWrapper } from "./AuthWrapper";

export const LoginPage = () => {
    const [formData, setFormData] = useState({
        identifier: '',
        password: '',
        client: 'react'
    });

    const [error, setError] = useState(null);
    const [isLoading, setIsLoading] = useState(false); // ✅ Tambahkan loading state
    const navigate = useNavigate();

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData((prevData) => ({
            ...prevData,
            [name]: value
        }));
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setError(null);
        setIsLoading(true); // ✅ Mulai loading

        try {
            const response = await fetch("http://localhost:3000/api/auth/login", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(formData)
            });

            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.message || "Login gagal");
            }

            const data = await response.json();

            localStorage.setItem("accessToken", data.token);
            localStorage.setItem("user", JSON.stringify(data.user));

        navigate("/dashboard");
        } catch (err) {
            setError(err.message);
        } finally {
            setIsLoading(false); // ✅ Selesai loading
        }
    };

    return (
        <AuthWrapper>
            <h4 className="mb-2 text-center">Balige Bersih</h4>
            <p className="mb-4 text-center">Silakan masuk ke akun Anda untuk mulai menggunakan sistem.</p>

            {error && <div className="alert alert-danger">{error}</div>}

            <form id="formAuthentication" className="mb-3" onSubmit={handleSubmit}>
                <div className="mb-3">
                    <label htmlFor="identifier" className="form-label">Email atau Nomor Telepon</label>
                    <input
                        type="text"
                        className="form-control"
                        id="identifier"
                        value={formData.identifier}
                        onChange={handleChange}
                        name="identifier"
                        placeholder="Masukkan email atau nomor telepon"
                        disabled={isLoading} // ⛔ Disable saat loading
                        autoFocus
                    />
                </div>
                <div className="mb-3 form-password-toggle">
                    <div className="d-flex justify-content-between">
                        <label className="form-label" htmlFor="password">Kata Sandi</label>
                    </div>
                    <div className="input-group input-group-merge">
                        <input
                            type="password"
                            autoComplete="true"
                            id="password"
                            value={formData.password}
                            onChange={handleChange}
                            className="form-control"
                            name="password"
                            placeholder="••••••••"
                            aria-describedby="password"
                            disabled={isLoading}
                        />
                    </div>
                </div>
                <div className="mb-3">
                    <button
                        aria-label="Klik untuk masuk"
                        className="btn btn-primary d-grid w-100"
                        type="submit"
                        disabled={isLoading} // ⛔ Disable saat loading
                    >
                        {isLoading ? (
                            <span className="d-flex justify-content-center align-items-center">
                                <span className="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
                                Memproses...
                            </span>
                        ) : (
                            "Masuk"
                        )}
                    </button>
                </div>
            </form>
        </AuthWrapper>
    );
};
