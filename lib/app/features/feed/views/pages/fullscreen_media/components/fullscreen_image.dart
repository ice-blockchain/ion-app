// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/utils/future.dart';

class FullscreenImage extends HookConsumerWidget {
  const FullscreenImage({
    required this.imageUrl,
    this.bottomOverlayBuilder,
    this.inPageView = false,
    super.key,
  });

  final String imageUrl;
  final Widget Function(BuildContext)? bottomOverlayBuilder;
  final bool inPageView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryTextColor = context.theme.appColors.primaryText;
    final minScale = 1.0.s;
    final maxScale = (6.0.s < minScale) ? minScale * 1.1 : 6.0.s;
    final animationController = useAnimationController(duration: 300.ms);
    final doubleTapScales = <double>[minScale, maxScale / 2];

    final animationListener = useRef<VoidCallback?>(null);

    useEffect(
      () {
        return () {
          if (animationListener.value != null) {
            animationController
                .drive(Tween<double>(begin: 0, end: 1))
                .removeListener(animationListener.value!);
          }
        };
      },
      [animationController],
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        ExtendedImage(
          image: CachedNetworkImageProvider(imageUrl),
          fit: BoxFit.contain,
          mode: ExtendedImageMode.gesture,
          enableSlideOutPage: true,
          initGestureConfigHandler: (state) {
            final effectiveMinScale = minScale;
            final effectiveMaxScale =
                (maxScale < effectiveMinScale) ? effectiveMinScale * 1.1 : maxScale;
            return GestureConfig(
              minScale: effectiveMinScale,
              maxScale: effectiveMaxScale,
              animationMinScale: effectiveMinScale * 0.8,
              animationMaxScale: effectiveMaxScale * 1.2,
              initialScale: effectiveMinScale,
              inPageView: inPageView,
            );
          },
          onDoubleTap: (ExtendedImageGestureState state) {
            final pointerDownPosition = state.pointerDownPosition;
            final begin = state.gestureDetails?.totalScale ?? minScale;
            double end;

            if (begin.isApproximately(doubleTapScales[0])) {
              end = doubleTapScales[1];
            } else {
              end = doubleTapScales[0];
            }

            final animation = animationController.drive(
              Tween<double>(
                begin: begin,
                end: end,
              ),
            );

            if (animationListener.value != null) {
              try {
                animation.removeListener(animationListener.value!);
              } catch (e) {
                debugPrint('Error removing previous listener: $e');
              }
            }

            animationListener.value = () {
              state.handleDoubleTap(
                scale: animation.value,
                doubleTapPosition: pointerDownPosition,
              );
            };

            animationController.reset();
            animation.addListener(animationListener.value!);
            animationController.forward();
          },
          loadStateChanged: (ExtendedImageState state) {
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                return ColoredBox(
                  color: primaryTextColor,
                  child: const CenteredLoadingIndicator(),
                );
              case LoadState.completed:
                return ColoredBox(
                  color: primaryTextColor,
                  child: state.completedWidget,
                );
              case LoadState.failed:
                return ColoredBox(
                  color: primaryTextColor,
                  child: Center(
                    child: Text(
                      'Failed to process image',
                      style: TextStyle(color: context.theme.appColors.onPrimaryAccent),
                    ),
                  ),
                );
            }
          },
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

extension DoubleExtension on double {
  bool isApproximately(double other, {double tolerance = 0.01}) {
    return (this - other).abs() < tolerance;
  }
}
