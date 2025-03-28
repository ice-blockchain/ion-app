// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class SheetDragHandle extends StatelessWidget implements PreferredSizeWidget {
  SheetDragHandle({
    super.key,
    double? topPadding,
  }) : topPadding = topPadding ?? _defaultTopPadding;

  final double topPadding;

  static double get _defaultTopPadding => 19.0.s;

  static double get _dragHandleHeight => 3.0.s;

  static double get _dragHandleWidth => 50.0.s;

  static double get _dragHandleBottomOffset => 8.0.s;

  @override
  Size get preferredSize => Size.fromHeight(
        topPadding + _dragHandleHeight + _dragHandleBottomOffset,
      );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsetsDirectional.only(bottom: 8.0.s),
        width: _dragHandleWidth,
        height: _dragHandleHeight,
        decoration: ShapeDecoration(
          color: context.theme.appColors.sheetLine,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1.5.s),
          ),
        ),
      ),
    );
  }
}
