import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';

class BottomMenuShadow extends StatelessWidget {
  const BottomMenuShadow({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  final Widget child;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: context.theme.appColors.primaryAccent.withOpacity(0.1),
            offset: Offset(0, -8.0.s),
            spreadRadius: -7.0.s,
            blurRadius: 8.0.s,
          )
        ],
      ),
      child: ColoredBox(
        color: backgroundColor ?? context.theme.appColors.secondaryBackground,
        child: child,
      ),
    );
  }
}
