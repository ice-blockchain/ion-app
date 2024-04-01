import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class SheetContent extends StatelessWidget {
  SheetContent({
    super.key,
    required this.body,
    double? topPadding,
    this.backgroundColor,
  }) : topPadding = topPadding ?? defaultPadding;

  final Widget body;
  final double topPadding;
  final Color? backgroundColor;

  static double get defaultPadding => 0.0.s;

  @override
  Widget build(BuildContext context) {
    //TODO::handle top offset without transition
    return SheetContentScaffold(
      backgroundColor:
          backgroundColor ?? context.theme.appColors.primaryBackground,
      body: body,
    );
  }
}
