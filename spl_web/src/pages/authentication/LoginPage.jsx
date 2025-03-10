import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import './page-auth.css';
import { AuthWrapper } from "./AuthWrapper";

export const LoginPage = () => {
    const [formData, setFormData] = useState({
        identifier: '',
        password: '',
        client: 'react' // Sesuaikan dengan frontend yang digunakan
    });

    const [error, setError] = useState(null);
    const [token, setToken] = useState(null); // Simpan token dalam state
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
                throw new Error(errorData.message || "Login failed");
            }
    
            const data = await response.json();
    
            // Simpan user dan token ke localStorage
            localStorage.setItem("accessToken", data.token);
            localStorage.setItem("user", JSON.stringify(data.user));
    
            navigate("/"); // Redirect ke dashboard
        } catch (err) {
            setError(err.message);
        }
    };
    
    

    return (
        <AuthWrapper>
            <h4 className="mb-2">Welcome to Sneat! 👋</h4>
            <p className="mb-4">Please sign in to your account and start the adventure</p>

            {error && <div className="alert alert-danger">{error}</div>}

            <form id="formAuthentication" className="mb-3" onSubmit={handleSubmit}>
                <div className="mb-3">
                    <label htmlFor="identifier" className="form-label">Email or Phone Number</label>
                    <input
                        type="text"
                        className="form-control"
                        id="identifier"
                        value={formData.identifier}
                        onChange={handleChange}
                        name="identifier"
                        placeholder="Enter your email or phone number"
                        autoFocus
                    />
                </div>
                <div className="mb-3 form-password-toggle">
                    <div className="d-flex justify-content-between">
                        <label className="form-label" htmlFor="password">Password</label>
                        <Link aria-label="Go to Forgot Password Page" to="/auth/forgot-password">
                            <small>Forgot Password?</small>
                        </Link>
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
                        />
                    </div>
                </div>
                <div className="mb-3">
                    <button aria-label='Click me' className="btn btn-primary d-grid w-100" type="submit">
                        Sign in
                    </button>
                </div>
            </form>

            <p className="text-center">
                <span>New on our platform? </span>
                <Link aria-label="Go to Register Page" to='/auth/register' className="registration-link">
                    <span>Create an account</span>
                </Link>
            </p>
        </AuthWrapper>
    );
};
