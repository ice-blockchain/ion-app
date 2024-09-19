// lib/widgets/camera_cell.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/camera/providers/media_service_provider.dart';

class CameraCell extends ConsumerWidget {
  const CameraCell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async => await ref.read(selectedImagesProvider.notifier).selectImageFromCamera(),
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Icon(
          Icons.camera_alt,
          size: 40,
          color: Colors.grey,
        ),
      ),
    );
  }
}
