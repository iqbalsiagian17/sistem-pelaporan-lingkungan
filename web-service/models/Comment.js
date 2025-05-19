module.exports = (sequelize, DataTypes) => {
    const Comment = sequelize.define(
        "Comment",
        {
            id: {
                type: DataTypes.INTEGER,
                autoIncrement: true,
                primaryKey: true
            },
            post_id: {
                type: DataTypes.INTEGER,
                allowNull: false,
                references: {
                    model: "Post",
                    key: "id"
                },
                onDelete: "CASCADE"
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
            },
            is_edited: {
            type: DataTypes.BOOLEAN,
            allowNull: false,
            defaultValue: false
            },
            parent_id: {
            type: DataTypes.INTEGER,
            allowNull: true,
            references: {
                model: "t_comment", // self-reference
                key: "id"
            },
            onDelete: "CASCADE"
          },

        },
        {
            tableName: "t_comment",
            timestamps: true
        }
    );

    Comment.associate = (models) => {
        Comment.belongsTo(models.Post, { foreignKey: "post_id", as: "post" });
        Comment.belongsTo(models.User, { foreignKey: "user_id", as: "user" });

        Comment.belongsTo(models.Comment, { foreignKey: "parent_id", as: "parent" });
        Comment.hasMany(models.Comment, { foreignKey: "parent_id", as: "replies" });

    };

    return Comment;
};
