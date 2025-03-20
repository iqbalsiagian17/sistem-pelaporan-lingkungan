module.exports = (sequelize, DataTypes) => {
    const PostLikes = sequelize.define(
      'PostLikes',
      {
        id: {
          type: DataTypes.INTEGER,
          autoIncrement: true,
          primaryKey: true,
        },
        user_id: {
          type: DataTypes.INTEGER,
          allowNull: false,
          references: {
            model: 't_user',
            key: 'id',
          },
          onDelete: 'CASCADE',
        },
        post_id: {
          type: DataTypes.INTEGER,
          allowNull: false,
          references: {
            model: 't_post',
            key: 'id',
          },
          onDelete: 'CASCADE',
        },
      },
      {
        tableName: 't_post_like',
        timestamps: true,
      }
    );
  
    // 🔹 **Relasi dengan model lain**
    PostLikes.associate = (models) => {
      PostLikes.belongsTo(models.User, { foreignKey: 'user_id', as: 'user' });
      PostLikes.belongsTo(models.Post, { foreignKey: 'post_id', as: 'post' });
    };
  
    return PostLikes;
  };
  