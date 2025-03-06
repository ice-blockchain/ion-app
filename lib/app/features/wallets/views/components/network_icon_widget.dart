// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:ion/app/extensions/extensions.dart';

class NetworkIconWidget extends StatelessWidget {
  const NetworkIconWidget({
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
      imageBuilder: (context, imageProvider) => Container(
        width: iconSize,
        height: iconSize,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
          ),
        ),
      ),
    );
  }
}
