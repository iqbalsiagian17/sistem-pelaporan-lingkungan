'use strict';
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('t_rating_report', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      report_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 't_report',
          key: 'id'
        },
        onDelete: 'CASCADE'
      },
      user_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 't_user',
          key: 'id'
        },
        onDelete: 'CASCADE'
      },
      rating: {
        type: Sequelize.INTEGER, // range 1 - 5
        allowNull: false
      },
      review: {
        type: Sequelize.TEXT,
        allowNull: true
      },
      round: {
        type: Sequelize.INTEGER,
        allowNull: false,
        defaultValue: 1 // pertama kali rating = round 1
      },
      is_latest: {
        type: Sequelize.BOOLEAN,
        allowNull: false,
        defaultValue: true // hanya 1 per report_id + user_id
      },
      rated_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP')
      }
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('t_rating_report');
  }
};
