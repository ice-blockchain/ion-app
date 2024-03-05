import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/utils/image.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.size,
    required this.imageUrl,
    this.borderRadius,
  });

  final double size;
  final String imageUrl;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(10.0.s),
      child: CachedNetworkImage(
        imageUrl: getAdaptiveImageUrl(imageUrl, size * 2),
        width: size,
        height: size,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
