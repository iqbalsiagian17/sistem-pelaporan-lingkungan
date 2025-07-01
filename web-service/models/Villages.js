module.exports = (sequelize, DataTypes) => {
  const Villages = sequelize.define(
    "Villages",
    {
      id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true
      },
      name: {
        type: DataTypes.STRING(100),
        allowNull: false,
        unique: true
      },
      boundary: {
        type: DataTypes.GEOMETRY('POLYGON'),
        allowNull: true
      }
    },
    {
      tableName: "t_villages",
      timestamps: true
    }
  );

  Villages.associate = (models) => {
      Villages.hasMany(models.Report, { foreignKey: 'village_id', as: 'reports' });
  };

  return Villages;
};
