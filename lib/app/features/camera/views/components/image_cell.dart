import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/camera/data/models/image_data.dart';
import 'package:ice/app/features/camera/providers/media_service_provider.dart';

class ImageCell extends ConsumerWidget {
  final ImageData imageData;

  const ImageCell({Key? key, required this.imageData}) : super(key: key);

  void _toggleSelection(BuildContext context, WidgetRef ref) {
    final selectedImages = ref.read(selectedImagesProvider);
    final isSelected = selectedImages.any((img) => img.id == imageData.id);

    if (isSelected) {
      ref.read(selectedImagesProvider.notifier).removeImage(imageData.id);
    } else {
      final maxSelection = ref.read(maxSelectionProvider);
      if (selectedImages.length >= maxSelection) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Максимум $maxSelection изображений.')),
        );
        return;
      }
      ref.read(selectedImagesProvider.notifier).addImage(
            imageData.copyWith(order: selectedImages.length + 1),
          );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImages = ref.watch(selectedImagesProvider);
    final isSelected = selectedImages.any((img) => img.id == imageData.id);
    final selectionOrder =
        isSelected ? selectedImages.firstWhere((img) => img.id == imageData.id).order : null;

    return GestureDetector(
      onTap: () => _toggleSelection(context, ref),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: imageData.thumbData != null
                ? Image.memory(
                    imageData.thumbData!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : Container(
                    color: Colors.grey,
                    width: double.infinity,
                    height: double.infinity,
                  ),
          ),
          if (isSelected)
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.blue,
                child: Text(
                  '$selectionOrder',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          if (isSelected)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
