import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // ✅ Format tanggal
import 'package:provider/provider.dart';
import 'package:spl_mobile/routes/app_routes.dart';
import '../../../../../providers/auth_provider.dart'; // ✅ Ambil akun user dari AuthProvider
import '../../../../../providers/user_profile_provider.dart'; // ✅ Ambil data user dari UserProfileProvider
import '../../../../../widgets/show_snackbar.dart';
import '../../../../../core/utils/validators.dart'; // ✅ Impor file validator

class ProfileEditForm extends StatefulWidget {
  const ProfileEditForm({super.key});

  @override
  State<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  String? _gender;

  bool _isSaving = false; // ✅ Tambahkan state untuk loading tombol Simpan

  @override
void initState() {
  super.initState();
  Future.microtask(() async {
    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<UserProfileProvider>();

    await profileProvider.loadUserInfo(); // ✅ Ambil data terbaru dari API

    if (!mounted) return; // ✅ Hindari error jika context tidak tersedia

    final user = authProvider.user;
    final userInfo = profileProvider.userInfo;

    if (user != null) {
      _usernameController.text = user.username;
      _emailController.text = user.email;
      _phoneController.text = user.phoneNumber;
    }

    // ✅ Tetap set data meskipun `null`
    setState(() {
      _fullNameController.text = userInfo?.fullName ?? '';  
      _addressController.text = userInfo?.address ?? ''; 
      _birthDateController.text = userInfo?.birthDate ?? ''; 
      _gender = (userInfo?.gender == "male" || userInfo?.gender == "female") ? userInfo?.gender : null; 
      _jobController.text = userInfo?.job ?? ''; 
    });

  });
}


  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _fullNameController.dispose();
    _addressController.dispose();
    _birthDateController.dispose();
    _jobController.dispose();
    super.dispose();
  }

  /// ✅ Fungsi untuk menyimpan data profile
  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    
    final profileProvider = context.read<UserProfileProvider>();

    bool success = await profileProvider.saveUserInfo({
      "username": _usernameController.text.trim(),
      "email": _emailController.text.trim(),
      "phone_number": _phoneController.text.trim(),
      "full_name": _fullNameController.text.trim(),
      "address": _addressController.text.trim(),
      "birth_date": _birthDateController.text.trim(),
      "gender": _gender,
      "job": _jobController.text.trim(),
    });

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      SnackbarHelper.showSnackbar(context, "Profil berhasil diperbarui!", isError: false);
      Future.microtask(() => context.go(AppRoutes.profile)); // ✅ Pindah halaman setelah update
    } else {
      SnackbarHelper.showSnackbar(context, "Gagal memperbarui profil", isError: true);
    }
  }

  /// ✅ Fungsi untuk menampilkan Date Picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        _birthDateController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, UserProfileProvider>(
      builder: (context, authProvider, profileProvider, child) {
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Informasi Akun", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                _buildTextField(_usernameController, "Username", Icons.person),
                _buildTextField(_emailController, "Email", Icons.email, validator: Validators.validateEmail),
                _buildTextField(_phoneController, "Nomor Telepon", Icons.phone, validator: Validators.validatePhone),
                
                const SizedBox(height: 20),
                const Text("Informasi Pribadi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                _buildTextField(_fullNameController, "Nama Lengkap", Icons.badge),
                _buildTextField(_addressController, "Alamat", Icons.home),
                _buildDatePickerField(_birthDateController, "Tanggal Lahir", Icons.calendar_today),
                _buildDropdown("Jenis Kelamin"), // ✅ Provide the required argument
                _buildTextField(_jobController, "Pekerjaan", Icons.work),

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveProfile, // ✅ Nonaktifkan tombol saat loading
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSaving
                        ? const CircularProgressIndicator(color: Colors.white) // ✅ Indikator loading
                        : const Text("Simpan", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ✅ Tambahkan _buildTextField()
  Widget _buildTextField(
    TextEditingController controller, 
    String label, 
    IconData icon, 
    {String? Function(String?)? validator}) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(TextEditingController controller, String label, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextFormField(
      controller: controller,
      readOnly: true, // ✅ Prevents manual input
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onTap: () => _selectDate(context), // ✅ Calls _selectDate when tapped
    ),
  );
}

Widget _buildDropdown(String label) {
  final Map<String, String> genderMap = {
    "male": "Laki-laki",
    "female": "Perempuan",
  };

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextFormField(
      controller: TextEditingController(text: _gender != null ? genderMap[_gender] : ""),
      readOnly: true, // ✅ Prevent manual typing
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.wc, color: Colors.grey),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green, width: 2), // ✅ Green border when focused
        ),
        filled: true,
        fillColor: Colors.white, // ✅ Background remains white
        suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.black), // ✅ Dropdown icon
      ),
      onTap: () => _showGenderPicker(context, genderMap),
    ),
  );
}

void _showGenderPicker(BuildContext context, Map<String, String> genderMap) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white, // ✅ Background color white
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // ✅ Rounded top corners
    ),
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: genderMap.entries.map((entry) {
            return ListTile(
              title: Text(entry.value, style: const TextStyle(fontSize: 16)),
              onTap: () {
                setState(() {
                  _gender = entry.key; // ✅ Update _gender variable
                });
                Navigator.pop(context); // ✅ Close the modal
              },
            );
          }).toList(),
        ),
      );
    },
  );
}





}
