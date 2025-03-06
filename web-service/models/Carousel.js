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
            image: {
                type: DataTypes.STRING,
                allowNull: false // Gambar wajib diisi
            }
        },
        {
            tableName: "t_carousel",
            timestamps: true
        }
    );
    return Carousel;
};
