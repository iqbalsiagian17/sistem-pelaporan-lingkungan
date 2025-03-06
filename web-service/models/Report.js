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
              type: DataTypes.ENUM('pending', 'rejected', 'verified', 'in_progress', 'completed', 'closed'),
              defaultValue: 'pending'
          },
          likes: {
              type: DataTypes.INTEGER,
              allowNull: false, // ✅ Pastikan tidak NULL
              defaultValue: 0  // ✅ Default 0 jika belum ada likes
          },
          village: {
              type: DataTypes.STRING(100),
              allowNull: true,
              defaultValue: "" // ✅ Ganti dari NULL ke string kosong
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
  };

  return Report;
};
