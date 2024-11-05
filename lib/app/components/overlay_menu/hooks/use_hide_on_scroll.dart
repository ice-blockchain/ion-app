// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useHideOnScroll(
  BuildContext context,
  OverlayPortalController overlayPortalController,
) {
  useEffect(
    () {
      void handleScrolling() {
        if (!overlayPortalController.isShowing) return;

        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (context.mounted && overlayPortalController.isShowing) {
            overlayPortalController.hide();
          }
        });
      }

      final scrollable = Scrollable.maybeOf(context);
      final isScrollingNotifier = scrollable?.position.isScrollingNotifier;

      isScrollingNotifier?.addListener(handleScrolling);

      return () => isScrollingNotifier?.removeListener(handleScrolling);
    },
    [overlayPortalController],
  );
}
