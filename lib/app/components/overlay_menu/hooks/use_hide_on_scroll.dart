// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useHideOnScroll(
  BuildContext context,
  OverlayPortalController overlayPortalController,
) {
  useEffect(
    () {
      final isScrollingNotifier = Scrollable.maybeOf(context)?.position.isScrollingNotifier;
      isScrollingNotifier?.addListener(overlayPortalController.hide);

      return () => isScrollingNotifier?.removeListener(overlayPortalController.hide);
    },
    [],
  );
}
