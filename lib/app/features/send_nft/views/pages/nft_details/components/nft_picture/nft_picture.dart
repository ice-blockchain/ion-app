import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/num.dart';

class NftPicture extends HookConsumerWidget {
  const NftPicture({
    required this.imageUrl,
    super.key,
  });

  double get imageWidth => 170;
  double get imageHeight => 170;

  final String imageUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0.s),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: imageWidth,
        height: imageHeight,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
