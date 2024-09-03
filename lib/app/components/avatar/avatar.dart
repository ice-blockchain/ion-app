import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ice/app/components/shapes/hexagon_path.dart';
import 'package:ice/app/components/shapes/shape.dart';
import 'package:ice/app/extensions/num.dart';

class Avatar extends StatelessWidget {
  Avatar({
    required this.size,
    super.key,
    this.imageUrl,
    this.badge,
    this.imageWidget,
    BorderRadiusGeometry? borderRadius,
    this.nft = false,
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
  final bool nft;
  final Widget? badge;
  final String? imageUrl;
  final Widget? imageWidget;

  @override
  Widget build(BuildContext context) {
    final image = imageWidget != null
        ? SizedBox(
            width: size,
            height: size,
            child: FittedBox(fit: fit, child: imageWidget),
          )
        : CachedNetworkImage(
            imageUrl: imageUrl!,
            width: size,
            height: size,
            fit: fit,
          );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        nft
            ? ClipPath(
                clipper: ShapeClipper(HexagonShapeBuilder(borderRadius: size / 5)),
                child: image,
              )
            : ClipRRect(borderRadius: borderRadius, child: image),
        if (badge != null) badge!,
      ],
    );
  }
}
