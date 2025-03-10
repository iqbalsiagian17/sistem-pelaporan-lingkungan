import { Route, Routes } from "react-router-dom";
import { DashboardPage } from "../pages/DashboardPage";
import { LoginPage } from "../pages/authentication/LoginPage";
import ProtectedRoute from "./ProtectedRoute";
import LaporanPage from "../pages/laporan/LapronaPage";

const AppRoutes = () => {
    return (
        <Routes>
            {/* Route Login */}
            <Route path="/auth/login" element={<LoginPage />} />

            {/* Protected Route untuk Dashboard */}
            <Route element={<ProtectedRoute />}>
                <Route path="/" element={<DashboardPage />} />
                <Route path="/reports/" element={<LaporanPage />} />
            </Route>
        </Routes>
    );
};

export default AppRoutes;
