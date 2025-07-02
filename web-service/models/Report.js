module.exports = (sequelize, DataTypes) => {
  const Report = sequelize.define(
      'Report',
      {
          id: {
              type: DataTypes.INTEGER,
              autoIncrement: true,
              primaryKey: true
          },
          user_id: {
              type: DataTypes.INTEGER,
              allowNull: false,
              defaultValue: 0, // ✅ Pastikan tidak NULL
              references: {
                  model: 'User',
                  key: 'id'
              },
              onDelete: 'CASCADE'
          },
          report_number: {
              type: DataTypes.STRING(20),
              allowNull: false,
              unique: true
          },
          title: {
              type: DataTypes.STRING(255),
              allowNull: false
          },
          description: {
              type: DataTypes.TEXT,
              allowNull: false
          },
          date: {
              type: DataTypes.DATEONLY,
              allowNull: false
          },
          status: {
              type: DataTypes.ENUM('pending', 'rejected', 'verified', 'in_progress', 'completed', 'closed', 'reopened', 'canceled', 'draft'),
              defaultValue: 'pending'
          },
          village_id: {
              type: DataTypes.INTEGER,
              allowNull: true,
              references: {
                model: 't_villages',
                key: 'id'
              },
              onDelete: 'SET NULL'
          },
          location_details: {
              type: DataTypes.TEXT,
              allowNull: true,
              defaultValue: "" // ✅ Ganti dari NULL ke string kosong
          },
          latitude: {
            type: DataTypes.DECIMAL(10, 8),
            allowNull: true,
            defaultValue: 0.0, // ✅ Pastikan tidak NULL
            get() {
              const value = this.getDataValue('latitude');
              return value !== null ? parseFloat(value) : 0.0;
            }
          },
          longitude: {
            type: DataTypes.DECIMAL(11, 8),
            allowNull: true,
            defaultValue: 0.0, // ✅ Pastikan tidak NULL
            get() {
              const value = this.getDataValue('longitude');
              return value !== null ? parseFloat(value) : 0.0;
            }
          },
          total_likes: {
            type: DataTypes.INTEGER,
            allowNull: false,
            defaultValue: 0, // 🔹 Default 0 jika belum ada likes
        },
          createdAt: {
            type: DataTypes.DATE,
            allowNull: false,
            defaultValue: DataTypes.NOW // ✅ Pastikan default waktu dibuat
          },
          updatedAt: {
            type: DataTypes.DATE,
            allowNull: false,
            defaultValue: DataTypes.NOW // ✅ Pastikan default waktu diperbarui
          }
      },
      {
          tableName: 't_report',
          timestamps: true
      }
  );

  Report.associate = (models) => {
      Report.hasMany(models.ReportAttachment, { foreignKey: 'report_id', as: 'attachments' });
      Report.belongsTo(models.User, { foreignKey: 'user_id', as: 'user' });
      Report.hasMany(models.ReportStatusHistory, { foreignKey: 'report_id', as: 'statusHistory' });
      Report.hasMany(models.UserReportLikeHistory, { foreignKey: 'report_id', as: 'likesRelation' });
      Report.hasMany(models.ReportEvidence, { foreignKey: 'report_id', as: 'evidences' });
      Report.hasOne(models.RatingReport, { foreignKey: 'report_id', as: 'rating' }); // ⬅ Ubah 'ratings' menjadi 'rating'
      Report.belongsTo(models.Villages, { foreignKey: 'village_id', as: 'village' });
    };

  return Report;
};
