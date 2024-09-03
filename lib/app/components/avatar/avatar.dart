import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';

class Avatar extends StatelessWidget {
  Avatar({
    required this.size,
    super.key,
    this.imageUrl,
    this.badge,
    this.imageWidget,
    BorderRadiusGeometry? borderRadius,
    BoxFit? fit,
  })  : borderRadius = borderRadius ?? BorderRadius.circular(10.0.s),
        fit = fit ?? BoxFit.fitWidth,
        assert(
          imageUrl == null || imageWidget == null,
          'Either imageUrl or imageWidget must be null',
        );

  final double size;
  final BorderRadiusGeometry borderRadius;
  final BoxFit fit;
  final Widget? badge;
  final String? imageUrl;
  final Widget? imageWidget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: borderRadius,
          child: imageWidget != null
              ? SizedBox(
                  width: size,
                  height: size,
                  child: imageWidget,
                )
              : CachedNetworkImage(
                  imageUrl: imageUrl!,
                  width: size,
                  height: size,
                  fit: fit,
                ),
        ),
        if (badge != null) badge!,
      ],
    );
  }
}
