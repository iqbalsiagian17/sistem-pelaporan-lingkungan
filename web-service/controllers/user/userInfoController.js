const userInfoService = require('../../services/userInfoService');

const createUserInfo = async (req, res) => {
    try {
        const { full_name, address, birth_date, gender, profile_picture, job } = req.body;
        const user_id = req.user.id; // Ambil user_id dari token JWT

        if (!full_name || !birth_date || !gender) {
            return res.status(400).json({ message: "Full Name, Birth Date, and Gender are required" });
        }

        const newUserInfo = await userInfoService.createUserInfo({
            user_id,
            full_name,
            address,
            birth_date,
            gender,
            profile_picture,
            job
        });

        res.status(201).json({ message: "UserInfo created successfully", data: newUserInfo });
    } catch (error) {
        console.error("Create UserInfo Error:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};

const getUserInfo = async (req, res) => {
    try {
        const user_id = req.user.id; // Ambil user_id dari token JWT
        const userInfo = await userInfoService.getUserInfoByUserId(user_id);

        if (!userInfo) {
            return res.status(404).json({ message: "UserInfo not found" });
        }

        res.json({ message: "UserInfo retrieved successfully", data: userInfo });
    } catch (error) {
        console.error("Get UserInfo Error:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};

const updateUserInfo = async (req, res) => {
    try {
        const user_id = req.user.id; // Ambil user_id dari token JWT
        const updatedData = req.body;

        const userInfo = await userInfoService.getUserInfoByUserId(user_id);
        if (!userInfo) {
            return res.status(404).json({ message: "UserInfo not found" });
        }

        await userInfoService.updateUserInfo(user_id, updatedData);
        res.json({ message: "UserInfo updated successfully" });
    } catch (error) {
        console.error("Update UserInfo Error:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};

const deleteUserInfo = async (req, res) => {
    try {
        const user_id = req.user.id; // Ambil user_id dari token JWT

        const userInfo = await userInfoService.getUserInfoByUserId(user_id);
        if (!userInfo) {
            return res.status(404).json({ message: "UserInfo not found" });
        }

        await userInfoService.deleteUserInfo(user_id);
        res.json({ message: "UserInfo deleted successfully" });
    } catch (error) {
        console.error("Delete UserInfo Error:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};

module.exports = { createUserInfo, getUserInfo, updateUserInfo, deleteUserInfo };
