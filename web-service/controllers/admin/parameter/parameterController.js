const { t_parameter } = require('../../../models');

// ✅ Public - Get Detail Parameter
exports.getPublicParameter = async (req, res) => {
  try {
    const parameter = await t_parameter.findOne({
      attributes: [
        "about",
        "terms",
        "report_guidelines",
        "emergency_contact",
        "ambulance_contact",
        "police_contact",
        "firefighter_contact",
        "landing_video"
      ],
      order: [["id", "ASC"]]
    });

    if (!parameter) {
      return res.status(404).json({
        success: false,
        message: "Parameter belum tersedia",
        data: null,
      });
    }

    res.status(200).json({
      success: true,
      message: "Data parameter berhasil diambil",
      data: parameter,
    });
  } catch (err) {
    console.error("❌ Error getPublicParameter:", err);
    res.status(500).json({
      success: false,
      message: "Terjadi kesalahan pada server",
      error: err.message,
    });
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
    const { id } = req.params;
    const user_id = req.user.id;

    const parameter = await t_parameter.findByPk(id);
    if (!parameter) {
      return res.status(404).json({ success: false, message: 'Parameter tidak ditemukan' });
    }

    if (parameter.user_id !== user_id) {
      return res.status(403).json({ success: false, message: 'Anda tidak memiliki izin' });
    }

    const landing_video = req.file
      ? `/uploads/videos/parameter/${req.file.filename}`
      : parameter.landing_video; // gunakan yang lama jika tidak ada file baru

    await parameter.update({
      ...req.body,
      landing_video,
      user_id,
    });

    res.status(200).json({
      success: true,
      message: 'Parameter berhasil diperbarui',
      data: parameter,
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      message: 'Terjadi kesalahan pada server',
      error: err.message,
    });
  }
};



// ✅ Admin - Create Parameter (jika belum ada)
exports.createParameter = async (req, res) => {
  try {
    const existing = await t_parameter.findOne();
    if (existing) {
      return res.status(400).json({ success: false, message: 'Parameter sudah tersedia' });
    }

    const user_id = req.user.id;

    // 👇 Tambahkan path video jika ada
    const landing_video = req.file ? `/uploads/videos/parameter/${req.file.filename}` : null;

    const created = await t_parameter.create({
      ...req.body,
      landing_video,
      user_id,
    });

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
    const { id } = req.params;

    const deleted = await t_parameter.destroy({ where: { id } });

    if (!deleted) {
      return res.status(404).json({ success: false, message: 'Parameter tidak ditemukan' });
    }

    res.status(200).json({ success: true, message: 'Parameter berhasil dihapus' });
  } catch (err) {
    res.status(500).json({
      success: false,
      message: 'Terjadi kesalahan pada server',
      error: err.message,
    });
  }
};
