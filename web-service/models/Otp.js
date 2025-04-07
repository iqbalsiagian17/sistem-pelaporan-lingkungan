'use strict';
const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class t_otp extends Model {
    static associate(models) {
      // define association here if needed
    }
  }

  t_otp.init({
    user_email: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    code: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    expired_at: {
      type: DataTypes.DATE,
      allowNull: false,
    },
    is_used: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    },
  }, {
    sequelize,
    modelName: 't_otp',
    tableName: 't_otp',
    timestamps: true, // createdAt & updatedAt otomatis
  });

  return t_otp;
};
