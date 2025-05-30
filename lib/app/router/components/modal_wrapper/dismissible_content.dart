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
    required this.isFullscreenMedia,
    super.key,
  });

  final Widget child;
  final GoRouterState state;
  final bool isFullscreenMedia;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isZoomed = ref.watch(imageZoomProvider);

    // 1. If zoomed - disable swipe.
    // 2. If fullscreen media (stories, chat media) - vertical only for natural dismiss gesture
    // 3. Otherwise (video feeds) - multi-directional
    final dismissDirection = isZoomed
        ? SwipeDismissDirection.none
        : (isFullscreenMedia ? SwipeDismissDirection.vertical : SwipeDismissDirection.multi);

    return DismissiblePage(
      onDismissed: () {
        if (context.canPop()) {
          context.pop();
        }
      },
      direction: dismissDirection,
      isZoomed: isZoomed,
      // For fullscreen media, keep background static (don't animate opacity)
      // where background stays fixed while content moves
      staticBackground: isFullscreenMedia,
      child: child,
    );
  }
}
