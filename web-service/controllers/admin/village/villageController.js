const { Villages } = require('../../../models');

// ✅ GET semua desa
exports.getAllVillages = async (req, res) => {
  try {
    const villages = await Villages.findAll({ order: [['name', 'ASC']] });
    res.status(200).json({ message: 'Data desa berhasil diambil', data: villages });
  } catch (error) {
    console.error('❌ Error getAllVillages:', error);
    res.status(500).json({ message: 'Gagal mengambil data desa', error: error.message });
  }
};

// ✅ GET desa berdasarkan ID
exports.getVillageById = async (req, res) => {
  try {
    const { id } = req.params;
    const village = await Villages.findByPk(id);

    if (!village) {
      return res.status(404).json({ message: 'Desa tidak ditemukan' });
    }

    res.status(200).json({ message: 'Detail desa berhasil diambil', data: village });
  } catch (error) {
    console.error('❌ Error getVillageById:', error);
    res.status(500).json({ message: 'Gagal mengambil data desa', error: error.message });
  }
};

// ✅ CREATE desa
exports.createVillage = async (req, res) => {
  try {
    const { name, boundary } = req.body;

    if (!name) {
      return res.status(400).json({ message: 'Nama desa wajib diisi' });
    }

    const village = await Villages.create({ name, boundary: boundary || null });

    res.status(201).json({ message: 'Desa berhasil ditambahkan', data: village });
  } catch (error) {
    console.error('❌ Error createVillage:', error);
    res.status(500).json({ message: 'Gagal menambahkan desa', error: error.message });
  }
};

// ✅ UPDATE desa
exports.updateVillage = async (req, res) => {
  try {
    const { id } = req.params;
    const { name, boundary } = req.body;

    const village = await Villages.findByPk(id);

    if (!village) {
      return res.status(404).json({ message: 'Desa tidak ditemukan' });
    }

    village.name = name || village.name;
    village.boundary = boundary !== undefined ? boundary : village.boundary;

    await village.save();

    res.status(200).json({ message: 'Desa berhasil diperbarui', data: village });
  } catch (error) {
    console.error('❌ Error updateVillage:', error);
    res.status(500).json({ message: 'Gagal memperbarui desa', error: error.message });
  }
};

// ✅ DELETE desa
exports.deleteVillage = async (req, res) => {
  try {
    const { id } = req.params;
    const village = await Villages.findByPk(id);

    if (!village) {
      return res.status(404).json({ message: 'Desa tidak ditemukan' });
    }

    await village.destroy();
    res.status(200).json({ message: 'Desa berhasil dihapus' });
  } catch (error) {
    console.error('❌ Error deleteVillage:', error);
    res.status(500).json({ message: 'Gagal menghapus desa', error: error.message });
  }
};
