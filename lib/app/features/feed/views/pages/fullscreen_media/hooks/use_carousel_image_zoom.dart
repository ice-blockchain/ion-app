// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/providers/image_zoom_state.c.dart';
import 'package:ion/app/utils/future.dart';

class CarouselImageZoomState {
  const CarouselImageZoomState({
    required this.transformationController,
    required this.onDoubleTapDown,
    required this.onDoubleTap,
    required this.onInteractionStart,
    required this.onInteractionEnd,
    required this.resetZoom,
  });

  final TransformationController transformationController;
  final void Function(TapDownDetails details) onDoubleTapDown;
  final VoidCallback onDoubleTap;
  final void Function(ScaleStartDetails details) onInteractionStart;
  final void Function(ScaleEndDetails details) onInteractionEnd;
  final VoidCallback resetZoom;
}

CarouselImageZoomState useCarouselImageZoom(WidgetRef ref) {
  final transformationController = useTransformationController();
  final animationController = useAnimationController(duration: 300.ms);
  final zoomNotifier = ref.watch(imageZoomStateProvider.notifier);

  final tapDownDetails = useState<TapDownDetails?>(null);
  final matrixAnimation = useState<Animation<Matrix4>?>(null);

  final context = useContext();
  final mounted = context.mounted;

  useEffect(() {
    void animationListener() {
      final anim = matrixAnimation.value;
      if (anim == null) return;

      transformationController.value = anim.value;
    }

    void animationStatusListener(AnimationStatus status) {
      if (!mounted) return;

      if (status == AnimationStatus.completed) {
        final currentlyZoomed = transformationController.value != Matrix4.identity();
        final alreadyZoomed = ref.read(imageZoomStateProvider);

        if (alreadyZoomed != currentlyZoomed) {
          zoomNotifier.zoomed = currentlyZoomed;
        }
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
  }, [
    animationController,
    matrixAnimation.value,
    transformationController,
    mounted,
  ]);

  void handleDoubleTap() {
    final details = tapDownDetails.value;
    if (details == null) return;

    final currentZoomState = ref.read(imageZoomStateProvider);
    final newZoomState = !currentZoomState;
    final position = details.localPosition;

    final endMatrix = newZoomState
        ? (Matrix4.identity()
          ..translate(-position.dx * 2, -position.dy * 2)
          ..scale(3.0))
        : Matrix4.identity();

    matrixAnimation.value = Matrix4Tween(
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
  }

  void handleInteractionStart(ScaleStartDetails details) {
    if (animationController.isAnimating) {
      animationController.stop();
    }
  }

  void handleInteractionEnd(ScaleEndDetails details) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final scale = transformationController.value.getMaxScaleOnAxis();
      final newZoomState = scale > 1.01;
      final currentZoomState = ref.read(imageZoomStateProvider);

      if (currentZoomState != newZoomState) {
        zoomNotifier.zoomed = newZoomState;
      }
    });
  }

  void resetZoom() {
    if (animationController.isAnimating) {
      animationController.stop();
    }

    if (transformationController.value != Matrix4.identity()) {
      matrixAnimation.value = Matrix4Tween(
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

      if (ref.read(imageZoomStateProvider)) {
        zoomNotifier.zoomed = false;
      }
    }
  }

  return CarouselImageZoomState(
    transformationController: transformationController,
    onDoubleTapDown: (details) => tapDownDetails.value = details,
    onDoubleTap: handleDoubleTap,
    onInteractionStart: handleInteractionStart,
    onInteractionEnd: handleInteractionEnd,
    resetZoom: resetZoom,
  );
}
