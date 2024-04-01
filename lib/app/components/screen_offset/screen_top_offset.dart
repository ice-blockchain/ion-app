import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';

class ScreenTopOffset extends StatelessWidget {
  ScreenTopOffset({
    super.key,
    required this.child,
    double? margin,
  }) : margin = margin ?? defaultMargin;

  static double get defaultMargin => 9.0.s;

  final Widget child;
  final double margin;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(top: margin),
        child: child,
      ),
    );
  }
}
