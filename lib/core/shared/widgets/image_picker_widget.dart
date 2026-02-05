import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/app_colors.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(File?)? onImageSelected;
  final String? initialImageUrl;
  final double size;

  const ImagePickerWidget({
    super.key,
    this.onImageSelected,
    this.initialImageUrl,
    this.size = 100,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        widget.onImageSelected?.call(_selectedImage);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
    widget.onImageSelected?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = _selectedImage != null || widget.initialImageUrl != null;

    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        children: [
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.neutral.withValues(alpha: 0.2),
              border: Border.all(color: AppColor.neutral, width: 2),
              image: hasImage
                  ? DecorationImage(
                      image: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : NetworkImage(widget.initialImageUrl!)
                                as ImageProvider,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: !hasImage
                ? Icon(
                    Icons.person,
                    size: widget.size * 0.5,
                    color: AppColor.neutral,
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: hasImage ? _removeImage : _pickImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColor.onboardingPrimary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  hasImage ? Icons.close : Icons.camera_alt,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
