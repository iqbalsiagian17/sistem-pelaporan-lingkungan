const { Op } = require('sequelize');
const { User } = require('../models');
const bcrypt = require('bcryptjs'); // ✅ Tambahkan ini


const findByPhoneOrEmail = async (identifier) => {
    return await User.findOne({
        where: {
            [Op.or]: [{ phone_number: identifier }, { email: identifier }]
        }
    });
};

const createUser = async (userData) => {
    return await User.create(userData);
};

const changePassword = async (user_id, oldPassword, newPassword) => {
    const user = await User.findByPk(user_id);

    if (!user) {
        throw new Error("User not found");
    }

    // Cek apakah password lama cocok
    const isMatch = await bcrypt.compare(oldPassword, user.password);
    if (!isMatch) {
        throw new Error("Old password is incorrect");
    }

    // Hash password baru
    const hashedPassword = await bcrypt.hash(newPassword, 10);

    // Update password di database
    await user.update({ password: hashedPassword });

    return { message: "Password changed successfully" };
};


module.exports = { findByPhoneOrEmail, createUser,changePassword };
