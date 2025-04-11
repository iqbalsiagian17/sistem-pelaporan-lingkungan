module.exports = (sequelize, DataTypes) => {
    const MediaCarousel = sequelize.define(
        "MediaCarousel",
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
            tableName: "t_media_carousels",
            timestamps: true
        }
    );
    return MediaCarousel;
};
