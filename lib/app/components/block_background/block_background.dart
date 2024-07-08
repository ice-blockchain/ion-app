import 'package:flutter/material.dart';
import 'package:ice/app/components/block_background/constants.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class BlockBackground extends StatelessWidget {
  const BlockBackground({
    required this.child,
    this.padding,
    this.margin,
    super.key,
  });

  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final BorderRadiusGeometry borderRadius = BorderRadius.circular(16.0.s);
    return Container(
      margin: margin ??
          EdgeInsets.only(top: BlockBackgroundConstants.verticalMargin),
      padding: padding ?? EdgeInsets.all(BlockBackgroundConstants.cellPadding),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: context.theme.appColors.tertararyBackground,
      ),
      child: child,
    );
  }
}
