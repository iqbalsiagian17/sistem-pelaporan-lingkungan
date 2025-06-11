import { Route, Routes } from "react-router-dom";
import { DashboardPage } from "../pages/dashboard/DashboardPage";
import { LoginPage } from "../pages/authentication/LoginPage";
import ProtectedRoute from "./ProtectedRoute";
import LaporanPage from "../pages/laporan/LapronaPage";
import UserManagementPage from "../pages/user/UserManagementPage";
import AnnouncementPage from "../pages/announcement/AnnouncementPage";
import MediaCarouselPage from "../pages/mediaCarousel/MediaCarouselPage";
import ParameterPage from "../pages/parameter/ParameterPage";
import ForumPage from "../pages/forum/ForumPage";
import LandingPage from "../pages/landing/LandingPage"; 

const AppRoutes = () => {
    return (
        <Routes>
            {/* ✅ Public routes */}
            <Route path="/" element={<LandingPage />} />
            <Route path="/login" element={<LoginPage />} />

            {/* 🔒 Protected routes */}
            <Route element={<ProtectedRoute />}>
                <Route path="/dashboard" element={<DashboardPage />} />
                <Route path="/reports" element={<LaporanPage />} />
                <Route path="/users" element={<UserManagementPage />} />
                <Route path="/announcements" element={<AnnouncementPage />} />
                <Route path="/banners" element={<MediaCarouselPage />} />
                <Route path="/parameters" element={<ParameterPage />} />
                <Route path="/forum" element={<ForumPage />} />
            </Route>
        </Routes>
    );
};

export default AppRoutes;
