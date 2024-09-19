import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/camera/providers/media_service_provider.dart';

import 'camera_cell.dart';
import 'image_cell.dart';

class CustomImagePicker extends ConsumerWidget {
  const CustomImagePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final galleryImagesAsync = ref.watch(galleryImagesProvider);
    final selectedImages = ref.watch(selectedImagesProvider);

    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final crossAxisCount = isPortrait ? 3 : 5;

    return Column(
      children: [
        Expanded(
          child: galleryImagesAsync.when(
            data: (images) {
              if (images.isEmpty) {
                return const Center(
                  child: Text('No images found'),
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: images.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const CameraCell();
                  } else {
                    final imageData = images[index - 1];
                    return ImageCell(
                      imageData: imageData,
                    );
                  }
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: selectedImages.isNotEmpty
                ? () {
                    for (var image in selectedImages) {
                      ref.read(selectedImagesProvider.notifier).addImage(image);
                    }

                    context.pop(selectedImages);
                  }
                : null,
            child: Text('Add (${selectedImages.length})'),
          ),
        ),
      ],
    );
  }
}
