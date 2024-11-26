// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';

class ImageStoryViewer extends StatelessWidget {
  const ImageStoryViewer({required this.path, super.key});

  final String path;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: path,
      fit: BoxFit.contain,
      width: double.infinity,
      filterQuality: FilterQuality.high,
      progressIndicatorBuilder: (_, __, ___) => const CenteredLoadingIndicator(),
      errorWidget: (context, url, error) => const SizedBox.shrink(),
    );
  }
}
