import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/camera/providers/providers.dart';

class CameraCell extends ConsumerWidget {
  const CameraCell({super.key});

  static final double cellHeight = 120.0.s;
  static final double cellWidth = 122.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraControllerAsync = ref.watch(cameraControllerProvider);

    return cameraControllerAsync.maybeWhen(
      data: (controller) {
        final isInitialized = controller?.value.isInitialized ?? false;

        return GestureDetector(
          onTap: () =>
              ref.read(imageSelectionNotifierProvider.notifier).captureAndAddImageFromCamera(),
          child: SizedBox(
            width: cellWidth,
            height: cellHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (isInitialized && controller != null)
                  AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  ),
                Center(
                  child: Icon(
                    Icons.camera_alt,
                    size: 40.0.s,
                    color: isInitialized ? Colors.white.withOpacity(0.7) : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
