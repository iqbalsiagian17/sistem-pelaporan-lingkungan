module.exports = (sequelize, DataTypes) => {
    const RatingReport = sequelize.define(
      "RatingReport",
      {
        id: {
          type: DataTypes.INTEGER,
          autoIncrement: true,
          primaryKey: true
        },
        report_id: {
          type: DataTypes.INTEGER,
          allowNull: false,
          references: {
            model: "Report",
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
        rating: {
          type: DataTypes.INTEGER,
          allowNull: false
        },
        review: {
          type: DataTypes.TEXT,
          allowNull: true
        },
        rated_at: {
          type: DataTypes.DATE,
          allowNull: false,
          defaultValue: DataTypes.NOW
        },
        auto_closed: {
          type: DataTypes.BOOLEAN,
          allowNull: false,
          defaultValue: false
        },
        createdAt: {
          type: DataTypes.DATE,
          allowNull: false,
          defaultValue: DataTypes.NOW
        },
        updatedAt: {
          type: DataTypes.DATE,
          allowNull: false,
          defaultValue: DataTypes.NOW
        }
      },
      {
        tableName: "t_rating_report",
        timestamps: true
      }
    );
  
    RatingReport.associate = (models) => {
      RatingReport.belongsTo(models.User, { foreignKey: "user_id", as: "user" });
      RatingReport.belongsTo(models.Report, { foreignKey: "report_id", as: "report" });
    };
  
    return RatingReport;
  };
  