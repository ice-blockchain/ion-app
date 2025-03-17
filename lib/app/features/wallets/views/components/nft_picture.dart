// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/image/app_cached_network_image.dart';
import 'package:ion/app/extensions/num.dart';

class NftPicture extends StatelessWidget {
  const NftPicture({
    required this.imageUrl,
    super.key,
  });

  static double get imageWidth => 170.0.s;
  static double get imageHeight => 170.0.s;

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0.s),
      child: AppCachedNetworkImage(
        imageUrl: imageUrl,
        width: imageWidth,
        height: imageHeight,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
