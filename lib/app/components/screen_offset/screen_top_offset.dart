// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/num.dart';

class ScreenTopOffset extends StatelessWidget {
  ScreenTopOffset({
    required this.child,
    super.key,
    double? margin,
  }) : margin = margin ?? defaultMargin;

  static double get defaultMargin => 9.0.s;

  final Widget child;
  final double margin;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsetsDirectional.only(top: margin),
        child: child,
      ),
    );
  }
}
