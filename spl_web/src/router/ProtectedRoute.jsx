import { Navigate, Outlet } from "react-router-dom";

const ProtectedRoute = () => {
    const token = localStorage.getItem("accessToken"); // Ambil token dari localStorage atau state

    return token ? <Outlet /> : <Navigate to="/auth/login" replace />;
};

export default ProtectedRoute;
