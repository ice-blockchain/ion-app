// SPDX-License-Identifier: ice License 1.0

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class SvgShadow extends StatelessWidget {
  const SvgShadow({
    required this.child,
    super.key,
    this.opacity = 0.5,
    this.sigma,
    this.color = Colors.black,
    this.offset,
  });
  final Widget child;
  final double opacity;
  final double? sigma;
  final Color color;
  final Offset? offset;

  @override
  Widget build(BuildContext context) {
    if (color.a == 0 || opacity == 0) {
      return child;
    }

    final shadowColor = color.withValues(alpha: opacity);

    return Stack(
      children: [
        Transform.translate(
          offset: offset ?? Offset(0, 1.5.s),
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaY: sigma ?? 1.5,
              sigmaX: sigma ?? 1.5,
              tileMode: TileMode.decal,
            ),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                shadowColor,
                BlendMode.srcIn,
              ),
              child: child,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
