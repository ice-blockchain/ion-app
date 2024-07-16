import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class SheetContent extends StatelessWidget {
  SheetContent({
    required this.body,
    super.key,
    double? topPadding,
    this.backgroundColor,
  }) : topPadding = topPadding ?? _defaultTopPadding;

  final Widget body;

  final double topPadding;

  final Color? backgroundColor;

  static double get _defaultTopPadding => 19.0.s;

  static double get _dragHandleHeight => 3.0.s;

  static double get _dragHandleWidth => 50.0.s;

  static double get _dragHandleBottomOffset => 8.0.s;

  @override
  Widget build(BuildContext context) {
    return SheetContentScaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      bottomBar: ScreenBottomOffset(),
      appBar: PreferredSize(
        preferredSize:
            Size(0, topPadding + _dragHandleHeight + _dragHandleBottomOffset),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: 8.0.s),
            width: _dragHandleWidth,
            height: _dragHandleHeight,
            decoration: ShapeDecoration(
              color: context.theme.appColors.sheetLine,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1.5.s),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: backgroundColor ?? context.theme.appColors.onPrimaryAccent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0.s),
            topRight: Radius.circular(30.0.s),
          ),
        ),
        child: body,
      ),
    );
  }
}
