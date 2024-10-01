// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';

class TrendingVideoListItemSkeleton extends StatelessWidget {
  const TrendingVideoListItemSkeleton({
    required this.itemSize,
    super.key,
  });

  final Size itemSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: itemSize.width,
      height: itemSize.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0.s),
        color: Colors.white,
      ),
    );
  }
}
