import 'package:flutter/material.dart';

const double kDefaultMargin = 44.0;
const EdgeInsets defaultInsets =
    EdgeInsets.symmetric(horizontal: kDefaultMargin);

class ScreenSideOffset extends StatelessWidget {
  const ScreenSideOffset({
    super.key,
    required this.child,
    EdgeInsets? insets,
  }) : insets = insets ?? defaultInsets;
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
