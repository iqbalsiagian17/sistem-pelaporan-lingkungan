'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
      await queryInterface.createTable("t_comment", {
          id: {
              type: Sequelize.INTEGER,
              autoIncrement: true,
              primaryKey: true
          },
          post_id: {
              type: Sequelize.INTEGER,
              allowNull: false,
              references: {
                  model: "t_post",
                  key: "id"
              },
              onDelete: "CASCADE"
          },
          user_id: {
              type: Sequelize.INTEGER,
              allowNull: false,
              references: {
                  model: "t_user",
                  key: "id"
              },
              onDelete: "CASCADE"
          },
          content: {
              type: Sequelize.TEXT,
              allowNull: false
          },
          is_edited: {
              type: Sequelize.BOOLEAN,
              allowNull: false,
              defaultValue: false
          },
           parent_id: {
            type: Sequelize.INTEGER,
            allowNull: true,
            references: {
                model: "t_comment", // self-reference
                key: "id"
            },
            onDelete: "CASCADE"
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
      await queryInterface.dropTable("t_comment");
  }
};
