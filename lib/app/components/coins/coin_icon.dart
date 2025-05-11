// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/image/ion_network_image.dart';
import 'package:ion/app/extensions/extensions.dart';
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

    return IonNetworkImage(
      imageUrl: imageUrl,
      width: iconSize,
      height: iconSize,
      errorWidget: (_, __, ___) => Assets.svg.walletEmptyicon.icon(size: iconSize),
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
