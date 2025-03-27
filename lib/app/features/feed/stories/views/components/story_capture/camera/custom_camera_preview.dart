// SPDX-License-Identifier: ice License 1.0

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';

class CustomCameraPreview extends HookWidget {
  const CustomCameraPreview({
    required this.controller,
    super.key,
  });

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    final showFocusCircle = useState(false);
    final focusPoint = useState((0.0, 0.0));

    if (!controller.value.isInitialized) {
      return const Center(child: IONLoadingIndicator());
    }

    final size = MediaQuery.sizeOf(context);
    final cameraAspectRatio = controller.value.aspectRatio;

    return GestureDetector(
      onTapUp: (tapDetails) => _onTap(context, tapDetails, focusPoint, showFocusCircle),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
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
            ),
          ),
          Positioned(
            top: focusPoint.value.$2 - 20.0.s,
            left: focusPoint.value.$1 - 20.0.s,
            child: _CameraFocusCircle(visible: showFocusCircle.value),
          ),
        ],
      ),
    );
  }

  Future<void> _onTap(
    BuildContext context,
    TapUpDetails tapDetails,
    ValueNotifier<(double, double)> focusPoint,
    ValueNotifier<bool> showFocusCircle,
  ) async {
    if (!controller.value.isInitialized) return;

    final (x, y) = (tapDetails.localPosition.dx, tapDetails.localPosition.dy);
    focusPoint.value = (x, y);
    showFocusCircle.value = true;

    final fullWidth = MediaQuery.of(context).size.width;
    final cameraHeight = fullWidth * controller.value.aspectRatio;

    final xp = x / fullWidth;
    final yp = y / cameraHeight;

    final point = Offset(xp, yp);

    await controller.setFocusPoint(point);
    await controller.setExposurePoint(point);

    await Future<void>.delayed(const Duration(seconds: 1)).whenComplete(() {
      showFocusCircle.value = false;
    });
  }
}

final class _CameraFocusCircle extends StatelessWidget {
  const _CameraFocusCircle({
    required this.visible,
  });

  final bool visible;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: !visible ? const Duration(milliseconds: 200) : Duration.zero,
      opacity: visible ? 1.0 : 0.0,
      child: Container(
        height: 40.0.s,
        width: 40.0.s,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 1.5.s,
          ),
        ),
      ),
    );
  }
}
