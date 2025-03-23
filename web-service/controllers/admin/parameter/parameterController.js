const { t_parameter } = require('../../../models');

// ✅ Public - Get Detail Parameter
exports.getPublicParameter = async (req, res) => {
  try {
    const parameter = await t_parameter.findOne({ where: { id: 1 } });

    if (!parameter) {
      return res.status(404).json({ success: false, message: 'Parameter belum tersedia' });
    }

    res.status(200).json({ success: true, data: parameter });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Terjadi kesalahan pada server', error: err.message });
  }
};

// ✅ Admin - Get All Parameter (meski hanya 1 row)
exports.getAllParameter = async (req, res) => {
  try {
    const parameters = await t_parameter.findAll({ order: [['id', 'ASC']] });

    res.status(200).json({
      success: true,
      message: 'Daftar parameter berhasil diambil',
      data: parameters,
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      message: 'Terjadi kesalahan pada server',
      error: err.message,
    });
  }
};

// ✅ Admin - Update Parameter
exports.updateParameter = async (req, res) => {
  try {
    const id = 1;
    const [affectedRows] = await t_parameter.update(req.body, { where: { id } });

    if (affectedRows === 0) {
      return res.status(404).json({ success: false, message: 'Parameter tidak ditemukan' });
    }

    const updated = await t_parameter.findByPk(id);
    res.status(200).json({
      success: true,
      message: 'Parameter berhasil diperbarui',
      data: updated,
    });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Terjadi kesalahan pada server', error: err.message });
  }
};

// ✅ Admin - Create Parameter (jika belum ada)
exports.createParameter = async (req, res) => {
  try {
    const existing = await t_parameter.findOne();
    if (existing) {
      return res.status(400).json({ success: false, message: 'Parameter sudah tersedia' });
    }

    const created = await t_parameter.create(req.body);
    res.status(201).json({
      success: true,
      message: 'Parameter berhasil dibuat',
      data: created,
    });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Terjadi kesalahan pada server', error: err.message });
  }
};

// ✅ Admin - Delete Parameter (optional)
exports.deleteParameter = async (req, res) => {
  try {
    const deleted = await t_parameter.destroy({ where: { id: 1 } });

    if (!deleted) {
      return res.status(404).json({ success: false, message: 'Parameter tidak ditemukan' });
    }

    res.status(200).json({ success: true, message: 'Parameter berhasil dihapus' });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Terjadi kesalahan pada server', error: err.message });
  }
};
