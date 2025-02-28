const { UserInfo } = require('../models');

const createUserInfo = async (data) => {
    return await UserInfo.create(data);
};

const getUserInfoByUserId = async (user_id) => {
    return await UserInfo.findOne({ where: { user_id } });
};

const updateUserInfo = async (user_id, updatedData) => {
    return await UserInfo.update(updatedData, { where: { user_id } });
};

const deleteUserInfo = async (user_id) => {
    return await UserInfo.destroy({ where: { user_id } });
};

module.exports = { createUserInfo, getUserInfoByUserId, updateUserInfo, deleteUserInfo };
