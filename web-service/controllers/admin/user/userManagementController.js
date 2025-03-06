const { User } = require('../../../models');

// ✅ GET ALL USERS
exports.getAllUsers = async (req, res) => {
    try {
        const users = await User.findAll({
            attributes: ["id", "username", "email", "phone_number", "type", "blocked_until"],
            order: [["createdAt", "DESC"]]
        });

        res.status(200).json({ message: "Users retrieved successfully", users });
    } catch (error) {
        console.error("Error fetching users:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};

// ✅ GET USER BY ID
exports.getUserById = async (req, res) => {
    try {
        const { id } = req.params;

        const user = await User.findByPk(id, {
            attributes: ["id", "username", "email", "phone_number", "type", "blocked_until"]
        });

        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        res.status(200).json({ message: "User retrieved successfully", user });
    } catch (error) {
        console.error("Error fetching user:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};

// ✅ UPDATE USER
exports.updateUser = async (req, res) => {
    try {
        const { id } = req.params;
        const updateData = req.body;

        const user = await User.findByPk(id);
        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        await user.update(updateData);
        res.status(200).json({ message: "User updated successfully", user });
    } catch (error) {
        console.error("Error updating user:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};

// ✅ DELETE USER
exports.deleteUser = async (req, res) => {
    try {
        const { id } = req.params;

        const user = await User.findByPk(id);
        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        await user.destroy();
        res.status(200).json({ message: "User deleted successfully" });
    } catch (error) {
        console.error("Error deleting user:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};

exports.blockUser = async (req, res) => {
    try {
        const { id } = req.params;
        const { blocked_until } = req.body;

        if (!blocked_until) {
            return res.status(400).json({ message: "Blocked until date is required" });
        }

        const user = await User.findByPk(id);
        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        await user.update({ blocked_until });

        res.status(200).json({ message: `User blocked until ${blocked_until}` });
    } catch (error) {
        console.error("Error blocking user:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};

// ✅ UNBLOCK USER
exports.unblockUser = async (req, res) => {
    try {
        const { id } = req.params;

        const user = await User.findByPk(id);
        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        await user.update({ blocked_until: null });

        res.status(200).json({ message: "User unblocked successfully" });
    } catch (error) {
        console.error("Error unblocking user:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};
