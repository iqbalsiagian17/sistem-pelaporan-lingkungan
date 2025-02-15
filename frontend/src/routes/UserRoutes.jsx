import { Routes, Route } from "react-router-dom";
import Home from "../pages/user/Home";
import Register from "../pages/auth/Register";

const UserRoutes = () => {
    return (
        <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/register" element={<Register />} />
        </Routes>
    );
};

export default UserRoutes;
