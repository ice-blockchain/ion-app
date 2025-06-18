// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ion/app/extensions/num.dart';

class IconAsset extends StatelessWidget {
  const IconAsset(
    this.asset, {
    super.key,
    double? size,
    this.fit,
    this.flipForRtl = false,
    this.colorFilter,
  }) : height = size, width = size;

  const IconAsset.rect(
    this.asset, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.flipForRtl = false,
    this.colorFilter,
  });

  final String asset;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final bool flipForRtl;
  final ColorFilter? colorFilter;

  @override
  Widget build(BuildContext context) {
    final svg = SvgPicture.asset(
      asset,
      width: width ?? 24.0.s,
      height: height ?? 24.0.s,
      excludeFromSemantics: true,
      fit: fit ?? BoxFit.contain,
      colorFilter: colorFilter,
    );

    if (!flipForRtl) return svg;

    final isRtl = Directionality.of(context) == TextDirection.rtl;
    if (!isRtl) {
      return svg;
    }
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(pi),
      child: svg,
    );
  }
}

class IconAssetColored extends StatelessWidget {
  const IconAssetColored(
    this.asset, {
    required this.color,
    super.key,
    this.size,
    this.fit,
    this.flipForRtl = false,
  });

  final String asset;
  final double? size;
  final BoxFit? fit;
  final bool flipForRtl;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final iconSize = size ?? 24.0.s;
    final colorFilter = ColorFilter.mode(color, BlendMode.srcIn);

    return IconAsset(
      asset,
      size: iconSize,
      fit: fit,
      flipForRtl: flipForRtl,
      colorFilter: colorFilter,
    );
  }
}
