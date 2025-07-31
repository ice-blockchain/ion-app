// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class RoundedCard extends StatelessWidget {
  factory RoundedCard.filled({
    required Widget child,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
  }) {
    return RoundedCard._(
      padding: padding,
      backgroundColor: backgroundColor,
      isOutlined: false,
      child: child,
    );
  }

  factory RoundedCard.outlined({
    required Widget child,
    EdgeInsetsGeometry? padding,
    Color? borderColor,
    Color? backgroundColor,
  }) {
    return RoundedCard._(
      padding: padding ?? EdgeInsets.zero,
      borderColor: borderColor,
      backgroundColor: backgroundColor,
      isOutlined: true,
      child: child,
    );
  }
  const RoundedCard._({
    required this.child,
    required this.isOutlined,
    this.padding,
    this.borderColor,
    this.backgroundColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final Color? backgroundColor;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(12.0.s),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0.s),
        color: backgroundColor ?? context.theme.appColors.terararyBackground,
        border: isOutlined
            ? Border.all(color: borderColor ?? context.theme.appColors.onSecondaryBackground)
            : null,
      ),
      child: child,
    );
  }
}
