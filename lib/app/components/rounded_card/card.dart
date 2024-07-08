import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class RoundedCard extends StatelessWidget {
  const RoundedCard({
    required this.child,
    this.padding,
    this.margin,
    super.key,
  });

  static double get cellPadding => 12.0.s;
  static double get verticalMargin => 12.0.s;

  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final BorderRadiusGeometry borderRadius = BorderRadius.circular(16.0.s);
    return Container(
      margin: margin ?? EdgeInsets.only(top: verticalMargin),
      padding: padding ?? EdgeInsets.all(cellPadding),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: context.theme.appColors.tertararyBackground,
      ),
      child: child,
    );
  }
}
