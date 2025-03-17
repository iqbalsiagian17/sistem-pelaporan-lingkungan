module.exports = (sequelize, DataTypes) => {
    const ReportLikes = sequelize.define(
        'ReportLikes',  // ✅ Nama Model
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
            report_id: {
                type: DataTypes.INTEGER,
                allowNull: false,
                references: {
                    model: 't_report',
                    key: 'id',
                },
                onDelete: 'CASCADE',
            },
            createdAt: {
                type: DataTypes.DATE,
                allowNull: false,
                defaultValue: DataTypes.NOW,
            },
            updatedAt: {
                type: DataTypes.DATE,
                allowNull: false,
                defaultValue: DataTypes.NOW,
            },
        },
        {
            tableName: 't_report_likes', // ✅ Gunakan nama tabel yang benar
            timestamps: true,
        }
    );

    ReportLikes.associate = (models) => {
        ReportLikes.belongsTo(models.User, { foreignKey: 'user_id', as: 'user' });
        ReportLikes.belongsTo(models.Report, { foreignKey: 'report_id', as: 'report' });
    };

    return ReportLikes;
};
