import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class SheetContent extends StatelessWidget {
  const SheetContent({
    super.key,
    required this.body,
    this.topPadding = 30.0,
  });

  final Widget body;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding.s),
      child: SheetContentScaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: body,
      ),
    );
  }
}
