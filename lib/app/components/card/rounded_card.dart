import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';

class RoundedCard extends StatelessWidget {
  // Add to widget book
  const RoundedCard({
    required this.child,
    this.padding,
    super.key,
  });

  static double get cellPadding => 12.0.s;

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final BorderRadiusGeometry borderRadius = BorderRadius.circular(16.0.s);
    return Container(
      padding: padding ?? EdgeInsets.all(cellPadding),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: context.theme.appColors.tertararyBackground,
      ),
      child: child,
    );
  }
}
