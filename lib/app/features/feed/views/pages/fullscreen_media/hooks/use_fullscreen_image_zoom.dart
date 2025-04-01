// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/providers/image_zoom_state.c.dart';

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
  final transformationController = useMemoized(TransformationController.new, const []);
  final animationController = useAnimationController(
    duration: const Duration(milliseconds: 300),
  );

  final zoomNotifier = ref.read(imageZoomStateProvider.notifier);
  final tapDownDetails = useState<TapDownDetails?>(null);
  final isZoomed = useState(false);
  final animation = useState<Animation<Matrix4>?>(null);

  useEffect(
    () {
      return transformationController.dispose;
    },
    const [],
  );

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
          isZoomed.value = currentlyZoomed;
          zoomNotifier.isZoomed = currentlyZoomed;
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

    final newZoomState = !isZoomed.value;
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

    isZoomed.value = newZoomState;
    zoomNotifier.isZoomed = newZoomState;
  }

  void handleInteractionEnd(ScaleEndDetails details) {
    final scale = transformationController.value.getMaxScaleOnAxis();

    if (scale < 1.0) {
      // Animate back to identity if scale is less than 1
      Future.microtask(() {
        animation.value = Matrix4Tween(
          begin: transformationController.value,
          end: Matrix4.identity(),
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.easeOut,
          ),
        );

        animationController
          ..reset()
          ..forward();

        isZoomed.value = false;
        zoomNotifier.isZoomed = false;
      });
    } else {
      final newZoomState = scale > 1.0;
      if (isZoomed.value != newZoomState) {
        isZoomed.value = newZoomState;
        zoomNotifier.isZoomed = newZoomState;
      }
    }
  }

  return FullscreenImageZoomState(
    transformationController: transformationController,
    onDoubleTapDown: (details) => tapDownDetails.value = details,
    onDoubleTap: handleDoubleTap,
    onInteractionEnd: handleInteractionEnd,
  );
}
