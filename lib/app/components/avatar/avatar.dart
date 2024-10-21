// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/components/shapes/hexagon_path.dart';
import 'package:ion/app/components/shapes/shape.dart';
import 'package:ion/app/extensions/extensions.dart';

class Avatar extends StatelessWidget {
  Avatar({
    required this.size,
    super.key,
    this.imageUrl,
    this.badge,
    this.imageWidget,
    BorderRadiusGeometry? borderRadius,
    this.hexagon = false,
    BoxFit? fit,
  })  : borderRadius = borderRadius ?? BorderRadius.circular(size * 0.3),
        fit = fit ?? BoxFit.fitWidth,
        assert(
          imageUrl == null || imageWidget == null,
          'Either imageUrl or imageWidget must be null',
        );

  final double size;
  final BorderRadiusGeometry borderRadius;
  final BoxFit fit;
  final bool hexagon;
  final Widget? badge;
  final String? imageUrl;
  final Widget? imageWidget;

  @override
  Widget build(BuildContext context) {
    final image = imageUrl != null
        ? CachedNetworkImage(
            imageUrl: imageUrl!,
            width: size,
            height: size,
            fit: fit,
            errorWidget: (context, url, error) {
              return SizedBox.square(
                dimension: size,
                child: ColoredBox(color: context.theme.appColors.onSecondaryBackground),
              );
            },
          )
        : SizedBox.square(
            dimension: size,
            child: FittedBox(
              fit: fit,
              child:
                  imageWidget ?? ColoredBox(color: context.theme.appColors.onSecondaryBackground),
            ),
          );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (hexagon)
          ClipPath(
            clipper: ShapeClipper(HexagonShapeBuilder()),
            child: image,
          )
        else
          ClipRRect(borderRadius: borderRadius, child: image),
        if (badge != null) badge!,
      ],
    );
  }
}
