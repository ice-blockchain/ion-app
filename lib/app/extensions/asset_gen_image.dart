// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/generated/assets.gen.dart';

extension IconExtension on AssetGenImage {
  Widget icon({Color? color, double? size, BoxFit? fit}) {
    final iconSize = size ?? 24.0.s;
    return Image.asset(
      path,
      width: iconSize,
      height: iconSize,
      excludeFromSemantics: true,
      fit: fit ?? BoxFit.contain,
      color: color,
    );
  }

  Widget iconWithDimensions({Color? color, double? width, double? height}) {
    final iconWidth = width ?? 24.0.s;
    final iconHeight = height ?? 24.0.s;
    return Image.asset(
      path,
      width: iconWidth,
      height: iconHeight,
      excludeFromSemantics: true,
      fit: BoxFit.contain,
      color: color,
    );
  }
}

extension IconStringExtension on String {
  Widget icon({
    Color? color,
    double? size,
    BoxFit? fit,
    bool flipForRtl = false,
  }) {
    final iconSize = size ?? 24.0.s;
    final colorFilter = color == null ? null : ColorFilter.mode(color, BlendMode.srcIn);

    final svg = SvgPicture.asset(
      this,
      width: iconSize,
      height: iconSize,
      excludeFromSemantics: true,
      fit: fit ?? BoxFit.contain,
      colorFilter: colorFilter,
    );

    if (!flipForRtl) return svg;

    return Builder(
      builder: (context) {
        final isRtl = Directionality.of(context) == TextDirection.rtl;
        if (!isRtl) {
          return svg;
        }
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(pi),
          child: svg,
        );
      },
    );
  }

  Widget iconWithDimensions({
    Color? color,
    double? width,
    double? height,
    bool flipForRtl = false,
  }) {
    final iconWidth = width ?? 24.0.s;
    final iconHeight = height ?? 24.0.s;
    final colorFilter = color == null ? null : ColorFilter.mode(color, BlendMode.srcIn);

    final svg = SvgPicture.asset(
      this,
      width: iconWidth,
      height: iconHeight,
      excludeFromSemantics: true,
      colorFilter: colorFilter,
    );

    if (!flipForRtl) return svg;

    return Builder(
      builder: (context) {
        final isRtl = Directionality.of(context) == TextDirection.rtl;
        if (!isRtl) {
          return svg;
        }
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(pi),
          child: svg,
        );
      },
    );
  }
}
