// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/router/components/sheet_content/sheet_drag_handle.dart';
import 'package:ice/app/router/components/sheet_content/sheet_shape.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class SheetContent extends StatelessWidget {
  const SheetContent({
    required this.body,
    super.key,
    this.bottomPadding,
    this.topPadding,
    this.backgroundColor,
  });

  final Widget body;

  final double? topPadding;

  final double? bottomPadding;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SheetContentScaffold(
      backgroundColor: Colors.transparent,
      primary: true,
      extendBody: true,
      bottomBar: const SizedBox.shrink(),
      appBar: SheetDragHandle(topPadding: topPadding),
      body: SheetShape(
        backgroundColor: backgroundColor,
        bottomPadding: bottomPadding,
        child: body,
      ),
    );
  }
}
