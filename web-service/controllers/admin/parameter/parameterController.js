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
        "landing_video",
        "location_validation_area",
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

// ✅ Admin - Get All Parameter
exports.getAllParameter = async (req, res) => {
  try {
    const parameters = await t_parameter.findAll({
      order: [['id', 'ASC']]
    });

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

// ✅ Admin - Create Parameter
exports.createParameter = async (req, res) => {
  try {
    const existing = await t_parameter.findOne();
    if (existing) {
      return res.status(400).json({ success: false, message: 'Parameter sudah tersedia' });
    }

    const user_id = req.user.id;
    const landing_video = req.file ? `/uploads/videos/parameter/${req.file.filename}` : null;
    const { location_validation_area, ...rest } = req.body;

    const created = await t_parameter.create({
      ...rest,
      landing_video,
      user_id,
      location_validation_area: location_validation_area ? JSON.parse(location_validation_area) : null,
    });

    res.status(201).json({
      success: true,
      message: 'Parameter berhasil dibuat',
      data: created,
    });
  } catch (err) {
    console.error('❌ Error createParameter:', err);
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
      : parameter.landing_video;

    // 🔍 Parse location_validation_area jika ada
    let location_validation_area = parameter.location_validation_area;
    if (req.body.location_validation_area) {
      try {
        const parsed = JSON.parse(req.body.location_validation_area);
        if (
          parsed.type === "Polygon" &&
          Array.isArray(parsed.coordinates)
        ) {
          location_validation_area = parsed;
        } else {
          return res.status(400).json({ success: false, message: "Format location_validation_area tidak valid" });
        }
      } catch (err) {
        return res.status(400).json({ success: false, message: "Gagal parsing location_validation_area", error: err.message });
      }
    }

    await parameter.update({
      ...req.body,
      landing_video,
      location_validation_area, // ✅ gunakan object GeoJSON, bukan string
      user_id,
    });

    res.status(200).json({
      success: true,
      message: 'Parameter berhasil diperbarui',
      data: parameter,
    });
  } catch (err) {
    console.error("❌ Error updateParameter:", err);
    res.status(500).json({
      success: false,
      message: 'Terjadi kesalahan pada server',
      error: err.message,
    });
  }
};


// ✅ Admin - Delete Parameter
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
