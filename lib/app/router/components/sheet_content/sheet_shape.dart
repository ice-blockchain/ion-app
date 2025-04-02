// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';

class SheetShape extends StatelessWidget {
  SheetShape({
    required this.child,
    super.key,
    this.backgroundColor,
    double? bottomPadding,
  }) : bottomPadding = bottomPadding ?? ScreenBottomOffset.defaultMargin;

  final Widget child;

  final double bottomPadding;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.theme.appColors.onPrimaryAccent,
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(30.0.s),
          topEnd: Radius.circular(30.0.s),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.only(bottom: bottomPadding),
        child: child,
      ),
    );
  }
}
