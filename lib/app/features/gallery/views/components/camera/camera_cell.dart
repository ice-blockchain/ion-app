import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/gallery/providers/providers.dart';
import 'package:ice/app/features/gallery/views/components/camera/camera.dart';
import 'package:ice/app/features/gallery/views/components/shimmer_loading_cell.dart';

class CameraCell extends ConsumerWidget {
  const CameraCell({super.key});

  static double get cellHeight => 120.0.s;
  static double get cellWidth => 122.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraControllerAsync = ref.watch(cameraControllerProvider);

    return cameraControllerAsync.maybeWhen(
      data: (controller) {
        final isInitialized = controller?.value.isInitialized ?? false;

        return GestureDetector(
          onTap: () async => ref.read(galleryNotifierProvider.notifier).captureImage(),
          child: SizedBox(
            width: cellWidth,
            height: cellHeight,
            child: isInitialized && controller != null
                ? CameraPreviewWidget(controller: controller)
                : const CameraPlaceholderWidget(),
          ),
        );
      },
      orElse: () => const ShimmerLoadingCell(),
    );
  }
}
