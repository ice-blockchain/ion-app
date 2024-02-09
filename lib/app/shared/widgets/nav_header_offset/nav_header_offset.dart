import 'package:flutter/material.dart';

const double kDefaultNavHeaderTopPadding = 50.0;
const EdgeInsets defaultInsets =
    EdgeInsets.only(top: kDefaultNavHeaderTopPadding);

class NavHeaderOffset extends StatelessWidget {
  const NavHeaderOffset({
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
