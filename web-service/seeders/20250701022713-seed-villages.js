'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    const villages = [
      "Desa Hutanamora",
      "Desa Hutagaol Peatalun",
      "Desa Hinalang Bagasan",
      "Desa Matio",
      "Desa Lumban Pea",
      "Desa Hutabulu Mejan",
      "Desa Lumban Gaol",
      "Desa Parsuratan",
      "Desa Baruara",
      "Desa Aek Bolon Julu",
      "Desa Sibolahotang SAS",
      "Desa Lumban Bulbul",
      "Desa Sianipar Sihailhail",
      "Desa Silalahi Pagar Batu",
      "Desa Lumban Silintong",
      "Desa Saribu Raja Janji Maria",
      "Desa Longat",
      "Desa Balige II",
      "Desa Aek Bolon Jae",
      "Desa Lumban Gorat",
      "Desa Sibuntuon",
      "Desa Siboruon",
      "Desa Paindoan",
      "Desa Bonan Dolok I",
      "Desa Bonan Dolok II",
      "Desa Bonan Dolok III",
      "Desa Huta Dame",
      "Kelurahan Balige I",
      "Kelurahan Balige III",
      "Kelurahan Pardede Onan",
      "Kelurahan Sangkar Nihuta",
      "Kelurahan Lumban Dolok Hauma Bange",
      "Kelurahan Napitupulu Bagasan",
      "Desa Lumban Pea Timur",
      "Desa Tambunan Sunge"
    ];

    const data = villages.map(name => ({
      name,
      boundary: null,
      createdAt: new Date(),
      updatedAt: new Date()
    }));

    await queryInterface.bulkInsert('t_villages', data, {});
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete('t_villages', null, {});
  }
};
