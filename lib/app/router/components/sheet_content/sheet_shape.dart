import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';

class SheetShape extends StatelessWidget {
  SheetShape({
    required this.child,
    super.key,
    this.backgroundColor,
  });

  final Widget child;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.theme.appColors.onPrimaryAccent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0.s),
          topRight: Radius.circular(30.0.s),
        ),
      ),
      child: child,
    );
  }
}
