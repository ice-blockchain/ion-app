// SPDX-License-Identifier: ice License 1.0

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class CameraPreviewWidget extends StatelessWidget {
  const CameraPreviewWidget({
    required this.controller,
    super.key,
  });

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.value.previewSize?.height,
              height: controller.value.previewSize?.width,
              child: CameraPreview(controller),
            ),
          ),
          Center(
            child: Assets.svg.iconCameraOpen.icon(
              size: 40.0.s,
              color: context.theme.appColors.onPrimaryAccent,
            ),
          ),
        ],
      ),
    );
  }
}
