// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/router/components/sheet_content/sheet_drag_handle.dart';
import 'package:ion/app/router/components/sheet_content/sheet_shape.dart';

Future<T?> showSimpleBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool useRootNavigator = true,
  bool isDismissible = true,
}) {
  return showModalBottomSheet<T>(
    useRootNavigator: useRootNavigator,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    context: context,
    builder: (context) {
      return PopScope(
        canPop: isDismissible,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SheetDragHandle(),
            SheetShape(child: child),
          ],
        ),
      );
    },
  );
}
