// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/num.dart';

class VideoPreviewLoading extends StatelessWidget {
  const VideoPreviewLoading({
    required this.width,
    required this.aspectRatio,
    super.key,
  });

  final double aspectRatio;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0.s),
      child: Skeleton(
        child: SizedBox(
          width: width,
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
