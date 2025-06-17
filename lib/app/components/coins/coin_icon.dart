// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ion/app/components/image/ion_network_image.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/utils/image_path.dart';
import 'package:ion/generated/assets.gen.dart';

enum CoinIconType {
  small,
  medium,
  big,
  huge,
}

class CoinIconWidget extends StatelessWidget {
  const CoinIconWidget._({
    required this.imageUrl,
    required this.type,
  });

  factory CoinIconWidget.withType(String imageUrl, CoinIconType type) {
    return CoinIconWidget._(
      imageUrl: imageUrl,
      type: type,
    );
  }

  factory CoinIconWidget.small(String imageUrl) {
    return CoinIconWidget._(
      imageUrl: imageUrl,
      type: CoinIconType.small,
    );
  }

  factory CoinIconWidget.medium(String imageUrl) {
    return CoinIconWidget._(
      imageUrl: imageUrl,
      type: CoinIconType.medium,
    );
  }

  factory CoinIconWidget.big(String imageUrl) {
    return CoinIconWidget._(
      imageUrl: imageUrl,
      type: CoinIconType.big,
    );
  }

  factory CoinIconWidget.huge(String imageUrl) {
    return CoinIconWidget._(
      imageUrl: imageUrl,
      type: CoinIconType.huge,
    );
  }

  final String imageUrl;
  final CoinIconType type;

  @override
  Widget build(BuildContext context) {
    final iconSize = _size(type);
    final borderRadius = _borderRadius(type);

    return imageUrl.isSvg
        ? ClipRRect(
            borderRadius: borderRadius,
            child: SvgPicture.network(
              imageUrl,
              width: iconSize,
              height: iconSize,
              errorBuilder: (_, __, ___) => IconAsset(Assets.svgWalletEmptyicon, size: iconSize),
            ),
          )
        : IonNetworkImage(
            imageUrl: imageUrl,
            width: iconSize,
            height: iconSize,
            errorWidget: (_, __, ___) => IconAsset(Assets.svgWalletEmptyicon, size: iconSize),
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

  double _size(CoinIconType type) {
    return switch (type) {
      CoinIconType.small => 16.s,
      CoinIconType.medium => 24.s,
      CoinIconType.big => 36.s,
      CoinIconType.huge => 46.s,
    };
  }

  BorderRadius _borderRadius(CoinIconType type) {
    return switch (type) {
      CoinIconType.small => BorderRadius.circular(5.s),
      CoinIconType.medium => BorderRadius.circular(7.s),
      CoinIconType.big => BorderRadius.circular(10.s),
      CoinIconType.huge => BorderRadius.circular(14.s),
    };
  }
}
