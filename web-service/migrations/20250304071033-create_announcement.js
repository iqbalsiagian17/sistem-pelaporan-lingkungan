'use strict';
module.exports = {
  up: async (queryInterface, Sequelize) => {
      await queryInterface.createTable("t_announcement", {
          id: {
              type: Sequelize.INTEGER,
              autoIncrement: true,
              primaryKey: true
          },
          title: {
              type: Sequelize.STRING,
              allowNull: false
          },
          description: {
              type: Sequelize.TEXT,
              allowNull: false
          },
          file: {
              type: Sequelize.STRING,
              allowNull: true
          },
          createdAt: {
              type: Sequelize.DATE,
              allowNull: false,
              defaultValue: Sequelize.fn("NOW")
          },
          updatedAt: {
              type: Sequelize.DATE,
              allowNull: false,
              defaultValue: Sequelize.fn("NOW")
          }
      });
  },

  down: async (queryInterface, Sequelize) => {
      await queryInterface.dropTable("t_announcement");
  }
};
