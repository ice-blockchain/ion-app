// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ion/app/components/image/ion_network_image.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/utils/image_path.dart';
import 'package:ion/generated/assets.gen.dart';

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
    final borderRadius = BorderRadius.circular(4.0.s);

    return imageUrl.isSvg
        ? ClipRRect(
            borderRadius: borderRadius,
            child: SvgPicture.network(
              imageUrl,
              width: iconSize,
              height: iconSize,
              errorBuilder: (_, __, ___) => Assets.svg.walletEmptyicon.icon(size: iconSize),
            ),
          )
        : IonNetworkImage(
            imageUrl: imageUrl,
            width: iconSize,
            height: iconSize,
            errorWidget: (_, __, ___) => Assets.svg.walletEmptyicon.icon(size: iconSize),
            imageBuilder: (context, imageProvider) => Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                image: DecorationImage(
                  image: imageProvider,
                ),
              ),
            ),
          );
  }
}
