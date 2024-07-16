import 'package:flutter/material.dart';
import 'package:ice/app/router/components/sheet_content/sheet_drag_handle.dart';
import 'package:ice/app/router/components/sheet_content/sheet_shape.dart';

Future<T?> showSimpleBottomSheet<T>({
  required BuildContext context,
  required Widget child,
}) {
  return showModalBottomSheet<T>(
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SheetDragHandle(),
          SheetShape(child: child),
        ],
      );
    },
  );
}
