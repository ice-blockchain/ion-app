// SPDX-License-Identifier: ice License 1.0

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';

class StoryCameraPreview extends StatelessWidget {
  const StoryCameraPreview({
    required this.controller,
    super.key,
  });

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const Center(child: IonLoadingIndicator());
    }

    final size = MediaQuery.sizeOf(context);
    final cameraAspectRatio = controller.value.aspectRatio;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0.s),
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: size.width,
          height: size.width / cameraAspectRatio,
          child: Center(
            child: CameraPreview(controller),
          ),
        ),
      ),
    );
  }
}
