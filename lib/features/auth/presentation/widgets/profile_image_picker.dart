import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moto_orbito/core/extensions/context_extensions.dart';
import 'package:moto_orbito/core/theme/spacing.dart';

final class ProfileImagePicker extends StatefulWidget {
  const ProfileImagePicker({
    required this.onImagePicked,
    this.imageBytes,
    super.key,
  });

  final void Function(Uint8List bytes, String name) onImagePicked;
  final Uint8List? imageBytes;

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

final class _ProfileImagePickerState extends State<ProfileImagePicker> {
  final _picker = ImagePicker();

  Future<void> _pickFromSource(ImageSource source) async {
    final xFile = await _picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (xFile == null) return;
    final bytes = await xFile.readAsBytes();
    widget.onImagePicked(bytes, xFile.name);
  }

  void _showOptions() {
    final t = context.t.auth.profilePicture;

    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colorScheme.onSurface.withAlpha(40),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: Spacing.lg),
              Text(
                t.pickPhoto,
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: Spacing.lg),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(t.camera),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickFromSource(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(t.gallery),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickFromSource(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final hasImage = widget.imageBytes != null;

    return GestureDetector(
      onTap: _showOptions,
      child: Stack(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.onSurface.withAlpha(15),
              border: Border.all(
                color: context.colors.neonAccent.withAlpha(100),
                width: 2,
              ),
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(55),
                    child: Image.memory(
                      widget.imageBytes!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.person_outline,
                    size: 48,
                    color: colors.onSurface.withAlpha(100),
                  ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.neonAccent,
                border: Border.all(
                  color: colors.surface,
                  width: 2.5,
                ),
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
