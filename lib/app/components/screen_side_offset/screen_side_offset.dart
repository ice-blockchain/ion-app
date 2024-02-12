import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';

class ScreenSideOffset extends StatelessWidget {
  const ScreenSideOffset._({
    super.key,
    required this.child,
    required this.insets,
  });

  // Factory constructor for large margin
  factory ScreenSideOffset.large({
    Key? key,
    required Widget child,
  }) {
    final EdgeInsets defaultLargeInsets =
        EdgeInsets.symmetric(horizontal: defaultLargeMargin);
    return ScreenSideOffset._(
      key: key,
      insets: defaultLargeInsets,
      child: child,
    );
  }

  // Factory constructor for small margin
  factory ScreenSideOffset.small({
    Key? key,
    required Widget child,
  }) {
    final EdgeInsets defaultSmallInsets =
        EdgeInsets.symmetric(horizontal: defaultSmallMargin);
    return ScreenSideOffset._(
      key: key,
      insets: defaultSmallInsets,
      child: child,
    );
  }

  static double get defaultSmallMargin => 16.0.s;

  static double get defaultLargeMargin => 44.0.s;

  final Widget child;
  final EdgeInsets insets;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: insets,
      child: child,
    );
  }
}
