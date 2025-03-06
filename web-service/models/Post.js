module.exports = (sequelize, DataTypes) => {
    const Post = sequelize.define(
        "Post",
        {
            id: {
                type: DataTypes.INTEGER,
                autoIncrement: true,
                primaryKey: true
            },
            user_id: {
                type: DataTypes.INTEGER,
                allowNull: false,
                references: {
                    model: "User",
                    key: "id"
                },
                onDelete: "CASCADE"
            },
            content: {
                type: DataTypes.TEXT,
                allowNull: false
            }
        },
        {
            tableName: "t_post",
            timestamps: true
        }
    );

    Post.associate = (models) => {
        Post.belongsTo(models.User, { foreignKey: "user_id", as: "user" });
        Post.hasMany(models.PostImage, { foreignKey: "post_id", as: "images" });
        Post.hasMany(models.Comment, { foreignKey: "post_id", as: "comments" });
    };

    return Post;
};
