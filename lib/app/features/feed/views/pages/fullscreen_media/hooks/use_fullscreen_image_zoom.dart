// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/providers/image_zoom_state.c.dart';
import 'package:ion/app/utils/future.dart';

class FullscreenImageZoomState {
  const FullscreenImageZoomState({
    required this.transformationController,
    required this.onDoubleTapDown,
    required this.onDoubleTap,
    required this.onInteractionEnd,
  });

  final TransformationController transformationController;
  final void Function(TapDownDetails details) onDoubleTapDown;
  final VoidCallback onDoubleTap;
  final void Function(ScaleEndDetails details) onInteractionEnd;
}

FullscreenImageZoomState useFullscreenImageZoom(WidgetRef ref) {
  final transformationController = useTransformationController();
  final animationController = useAnimationController(duration: 300.ms);

  final zoomNotifier = ref.watch(imageZoomStateProvider.notifier);
  final tapDownDetails = useState<TapDownDetails?>(null);
  final animation = useState<Animation<Matrix4>?>(null);

  useEffect(
    () {
      void animationListener() {
        if (animation.value != null) {
          transformationController.value = animation.value!.value;
        }
      }

      void animationStatusListener(AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          final currentlyZoomed = transformationController.value != Matrix4.identity();
          zoomNotifier.zoomed = currentlyZoomed;
        }
      }

      animationController
        ..addListener(animationListener)
        ..addStatusListener(animationStatusListener);

      return () {
        animationController
          ..removeListener(animationListener)
          ..removeStatusListener(animationStatusListener);
      };
    },
    const [],
  );

  void handleDoubleTap() {
    if (tapDownDetails.value == null) return;

    final currentZoomState = ref.read(imageZoomStateProvider);
    final newZoomState = !currentZoomState;
    final position = tapDownDetails.value!.localPosition;

    final endMatrix = newZoomState
        ? (Matrix4.identity()
          ..translate(-position.dx * 2, -position.dy * 2)
          ..scale(3.0))
        : Matrix4.identity();

    animation.value = Matrix4Tween(
      begin: transformationController.value,
      end: endMatrix,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
    );

    animationController
      ..reset()
      ..forward();

    zoomNotifier.zoomed = newZoomState;
  }

  void handleInteractionEnd(ScaleEndDetails details) {
    final scale = transformationController.value.getMaxScaleOnAxis();

    final newZoomState = scale > 1.0;
    final currentZoomState = ref.read(imageZoomStateProvider);
    if (currentZoomState != newZoomState) {
      zoomNotifier.zoomed = newZoomState;
    }
  }

  return FullscreenImageZoomState(
    transformationController: transformationController,
    onDoubleTapDown: (details) => tapDownDetails.value = details,
    onDoubleTap: handleDoubleTap,
    onInteractionEnd: handleInteractionEnd,
  );
}
