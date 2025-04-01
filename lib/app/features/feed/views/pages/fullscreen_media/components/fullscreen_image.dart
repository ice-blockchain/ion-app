// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/providers/image_zoom_state.c.dart';

class FullscreenImage extends HookConsumerWidget {
  const FullscreenImage({
    required this.imageUrl,
    this.bottomOverlayBuilder,
    super.key,
  });

  final String imageUrl;
  final Widget Function(BuildContext)? bottomOverlayBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    final primaryTextColor = context.theme.appColors.primaryText;
    final maxScale = 6.0.s;

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: primaryTextColor,
          child: GestureDetector(
            onDoubleTapDown: (details) => tapDownDetails.value = details,
            onDoubleTap: handleDoubleTap,
            child: InteractiveViewer(
              transformationController: transformationController,
              minScale: 0.5,
              maxScale: maxScale,
              onInteractionEnd: (_) {
                final newZoomState = transformationController.value != Matrix4.identity();

                if (isZoomed.value != newZoomState) {
                  isZoomed.value = newZoomState;
                  zoomNotifier.isZoomed = newZoomState;
                }
              },
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (_, __) => const CenteredLoadingIndicator(),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        if (bottomOverlayBuilder != null)
          PositionedDirectional(
            start: 0,
            end: 0,
            bottom: 0,
            child: bottomOverlayBuilder!(context),
          ),
      ],
    );
  }
}
