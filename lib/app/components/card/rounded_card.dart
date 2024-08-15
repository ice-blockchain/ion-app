import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';

class RoundedCard extends StatelessWidget {
  const RoundedCard._({
    required this.child,
    this.padding,
    this.borderColor,
    this.backgroundColor,
  });

  static double get cellPadding => 12.0.s;

  final Widget child;
  final EdgeInsets? padding;
  final Color? borderColor;
  final Color? backgroundColor;

  factory RoundedCard.filled({
    required Widget child,
    EdgeInsets? padding,
    Color? backgroundColor,
  }) {
    return RoundedCard._(
      child: child,
      padding: padding,
      backgroundColor: backgroundColor,
    );
  }

  factory RoundedCard.outlined({
    required Widget child,
    EdgeInsets? padding,
    Color? borderColor,
    Color? backgroundColor,
  }) {
    return RoundedCard._(
      child: child,
      padding: padding ?? EdgeInsets.zero,
      borderColor: borderColor,
      backgroundColor: backgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(16.0.s);
    final Color? color = borderColor ?? context.theme.appColors.onTerararyFill;

    return Container(
      padding: padding ?? EdgeInsets.all(cellPadding),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: backgroundColor ?? context.theme.appColors.tertararyBackground,
        border: color != null ? Border.all(color: color) : null,
      ),
      child: child,
    );
  }
}
