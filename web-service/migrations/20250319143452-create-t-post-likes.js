module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('t_post_like', {
      id: {
        type: Sequelize.INTEGER,
        autoIncrement: true,
        primaryKey: true,
      },
      user_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 't_user', // ✅ Referensi ke tabel user
          key: 'id',
        },
        onDelete: 'CASCADE',
      },
      post_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 't_post', // ✅ Referensi ke tabel post
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

    // ✅ Tambahkan unique constraint agar user tidak bisa like postingan lebih dari sekali
    await queryInterface.addConstraint('t_post_like', {
      fields: ['user_id', 'post_id'],
      type: 'unique',
      name: 'unique_user_post_like',
    });
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.dropTable('t_post_like');
  }
};
