'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
      await queryInterface.createTable("t_carousel", {
          id: {
              type: Sequelize.INTEGER,
              autoIncrement: true,
              primaryKey: true
          },
          title: {
              type: Sequelize.STRING,
              allowNull: true
          },
          description: { // ✅ Tambahkan deskripsi
              type: Sequelize.TEXT,
              allowNull: true // Boleh kosong
          },
          image: {
              type: Sequelize.STRING,
              allowNull: false
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
      await queryInterface.dropTable("t_carousel");
  }
};
