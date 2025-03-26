import { Route, Routes } from "react-router-dom";
import { DashboardPage } from "../pages/DashboardPage";
import { LoginPage } from "../pages/authentication/LoginPage";
import ProtectedRoute from "./ProtectedRoute";
import LaporanPage from "../pages/laporan/LapronaPage";
import UserManagementPage from "../pages/user/UserManagementPage";
import AnnouncementPage from "../pages/announcement/AnnouncementPage";
import CarouselPage from "../pages/carousel/CarouselPage";
import ParameterPage from "../pages/parameter/ParameterPage";
import ForumPage from "../pages/forum/ForumPage";

const AppRoutes = () => {
    return (
        <Routes>
            {/* Route Login */}
            <Route path="/auth/login" element={<LoginPage />} />

            {/* Protected Route untuk Dashboard */}
            <Route element={<ProtectedRoute />}>
                <Route path="/" element={<DashboardPage />} />
                <Route path="/reports/" element={<LaporanPage />} />
                <Route path="/users/" element={<UserManagementPage  />} />
                <Route path="/announcements/" element={<AnnouncementPage  />} />
                <Route path= "/banners/" element={<CarouselPage  />} />
                <Route path="/parameters/" element={<ParameterPage />} />
                <Route path="/forum" element={<ForumPage/>} />
            </Route>
        </Routes>
    );
};

export default AppRoutes;
