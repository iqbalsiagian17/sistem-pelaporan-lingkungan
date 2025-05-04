'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable("t_post_image", {
      id: {
        type: Sequelize.INTEGER,
        autoIncrement: true,
        primaryKey: true,
        allowNull: false,
      },
      post_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: "t_post", // ✅ nama tabel, bukan nama model
          key: "id"
        },
        onUpdate: "CASCADE", // ✅ Tambahkan untuk menjaga integritas relasi
        onDelete: "CASCADE"
      },
      image: {
        type: Sequelize.STRING,
        allowNull: false,
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
    await queryInterface.dropTable("t_post_image");
  }
};
