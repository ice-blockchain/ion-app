import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PostMediaImage extends StatelessWidget {
  const PostMediaImage({
    required this.imageUrl,
    required this.aspectRatio,
    super.key,
  });

  final String imageUrl;

  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
    );
  }
}
