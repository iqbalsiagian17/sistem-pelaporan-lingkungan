module.exports = (sequelize, DataTypes) => {
    const Carousel = sequelize.define(
        "Carousel",
        {
            id: {
                type: DataTypes.INTEGER,
                autoIncrement: true,
                primaryKey: true
            },
            title: {
                type: DataTypes.STRING,
                allowNull: false
            },
            description: { // ✅ Tambahkan deskripsi
                type: DataTypes.TEXT,
                allowNull: true // Boleh kosong
            },
            image: {
                type: DataTypes.STRING,
                allowNull: false
            }
        },
        {
            tableName: "t_carousel",
            timestamps: true
        }
    );
    return Carousel;
};
