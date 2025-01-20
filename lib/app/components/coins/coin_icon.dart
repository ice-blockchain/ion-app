import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class CoinIconWidget extends StatelessWidget {
  const CoinIconWidget({
    required this.imageUrl,
    super.key,
    this.size,
  });

  final String imageUrl;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final iconSize = size ?? 24.0.s;

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: iconSize,
      height: iconSize,
      // TODO: Not implemented
      errorWidget: (_, __, ___) => const SizedBox.shrink(),
      imageBuilder: (context, imageProvider) => Container(
        width: iconSize,
        height: iconSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
          ),
        ),
      ),
    );
  }
}
