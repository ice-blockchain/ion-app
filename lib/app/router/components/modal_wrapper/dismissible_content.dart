// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/providers/image_zoom_provider.c.dart';
import 'package:ion/app/router/components/modal_wrapper/dismissible_page.dart';

class DismissibleContent extends ConsumerWidget {
  const DismissibleContent({
    required this.child,
    required this.state,
    required this.isFullscreenImage,
    super.key,
  });

  final Widget child;
  final GoRouterState state;
  final bool isFullscreenImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isZoomed = ref.watch(imageZoomProvider);

    // 1. If zoom is enabled, disable swipe.
    // 2. If it's a fullscreen image, use only vertical direction.
    // 3. Otherwise (e.g., "the trending video list"), allow swipe in all directions (multi).
    final dismissDirection = isZoomed
        ? SwipeDismissDirection.none
        : (isFullscreenImage ? SwipeDismissDirection.vertical : SwipeDismissDirection.multi);

    return DismissiblePage(
      onDismissed: () {
        if (context.canPop()) {
          context.pop();
        }
      },
      direction: dismissDirection,
      isZoomed: isZoomed,
      child: child,
    );
  }
}
