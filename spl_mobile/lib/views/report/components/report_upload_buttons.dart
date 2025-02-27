import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReportUploadButtons extends StatelessWidget {
  final bool isAtLocation;

  const ReportUploadButtons({super.key, required this.isAtLocation});

  Future<void> _pickImage(bool fromCamera) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedFile != null) {
      // TODO: Handle image upload (store or display image)
      print("File dipilih: ${pickedFile.path}");
    }
  }

  Future<void> _pickPDF() async {
    // TODO: Tambahkan fungsi untuk upload file PDF
    print("Upload PDF");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _pickImage(isAtLocation),
            icon: const Icon(Icons.add_a_photo, color: Color.fromRGBO(76, 175, 80, 1)),
            label: Text(
              isAtLocation ? "Ambil Foto" : "Tambah Foto",
              style: const TextStyle(color: Color.fromRGBO(76, 175, 80, 1)),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: Color.fromRGBO(76, 175, 80, 1)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        if (!isAtLocation) ...[
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _pickPDF,
              icon: const Icon(Icons.picture_as_pdf, color: Color.fromRGBO(76, 175, 80, 1)),
              label: const Text("Tambah File (PDF)", style: TextStyle(color: Color.fromRGBO(76, 175, 80, 1))),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: Color.fromRGBO(76, 175, 80, 1)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
