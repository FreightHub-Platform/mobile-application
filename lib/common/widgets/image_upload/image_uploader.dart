import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageUploadContainer extends StatelessWidget {
  final String label;
  final File? imageFile;
  final Function(String) onImagePick;
  final bool isRequired;

  const ImageUploadContainer({
    super.key,
    required this.label,
    required this.imageFile,
    required this.onImagePick,
    this.isRequired = true,
  });

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        onImagePick(image.path);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showImagePickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () => _showImagePickerModal(context),
        child: Row(
          children: [
            if (imageFile == null) ...[
              const Icon(Icons.add_a_photo),
              const SizedBox(width: 10),
              Text('$label ${isRequired ? '*' : ''}'),
            ] else ...[
              Expanded(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        imageFile!,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text("Image selected"),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showImagePickerModal(context),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}