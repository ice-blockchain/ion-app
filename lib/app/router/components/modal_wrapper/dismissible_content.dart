// SPDX-License-Identifier: ice License 1.0

import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/providers/image_zoom_state.c.dart';

class DismissibleContent extends ConsumerWidget {
  const DismissibleContent({
    required this.child,
    required this.state,
    super.key,
  });

  final Widget child;
  final GoRouterState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isZoomed = ref.watch(imageZoomStateProvider);

    return DismissiblePage(
      onDismissed: () {
        if (context.canPop()) {
          context.pop();
        }
      },
      direction:
          isZoomed ? DismissiblePageDismissDirection.none : DismissiblePageDismissDirection.none,
      child: child,
    );
  }
}
