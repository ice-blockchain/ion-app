import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class CameraPreviewWidget extends StatelessWidget {
  const CameraPreviewWidget({
    required this.controller,
    super.key,
  });

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
        Center(
          child: Assets.svg.iconCameraOpen.icon(
            size: 40.0.s,
            color: context.theme.appColors.onPrimaryAccent,
          ),
        ),
      ],
    );
  }
}
