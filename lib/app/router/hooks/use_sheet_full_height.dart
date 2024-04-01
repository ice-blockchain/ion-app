import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

/// Calculates the max bottom sheet viewport height.
///
/// Useful when we need to build layout that takes the full height on
/// big devices but keep the possibility to scroll on small ones.
double useSheetFullHeight(BuildContext context) {
  return useMemoized(
    () =>
        MediaQuery.of(context).size.height -
        // MediaQuery.of(context).padding.top does not work for bottom sheets
        View.of(context).padding.top / View.of(context).devicePixelRatio -
        SheetContent.defaultPadding,
    <Object?>[],
  );
}
