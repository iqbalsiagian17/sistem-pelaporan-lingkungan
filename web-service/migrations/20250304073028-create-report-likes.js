'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('t_report_likes', {
      id: {
        type: Sequelize.INTEGER,
        autoIncrement: true,
        primaryKey: true,
      },
      user_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 't_user',
          key: 'id',
        },
        onDelete: 'CASCADE',
      },
      report_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 't_report',
          key: 'id',
        },
        onDelete: 'CASCADE',
      },
      createdAt: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
      },
      updatedAt: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'),
      },
    });

    // ✅ Tambahkan constraint agar 1 user hanya bisa like 1 laporan
    await queryInterface.addConstraint('t_report_likes', {
      fields: ['user_id', 'report_id'],
      type: 'unique',
      name: 'unique_user_report_like',
    });
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.dropTable('t_report_likes');
  },
};
