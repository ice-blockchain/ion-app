import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';

double defaultNavHeaderTopPadding = 50.s;
EdgeInsets defaultInsets = EdgeInsets.only(top: defaultNavHeaderTopPadding);

class NavHeaderOffset extends StatelessWidget {
  NavHeaderOffset({
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
