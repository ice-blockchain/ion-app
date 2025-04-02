// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/num.dart';

class ScreenBottomOffset extends StatelessWidget {
  ScreenBottomOffset({
    super.key,
    this.child,
    double? margin,
  }) : margin = margin ?? defaultMargin;

  static double get defaultMargin => 12.0.s;

  final Widget? child;
  final double margin;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsDirectional.only(bottom: margin),
        child: child,
      ),
    );
  }
}
