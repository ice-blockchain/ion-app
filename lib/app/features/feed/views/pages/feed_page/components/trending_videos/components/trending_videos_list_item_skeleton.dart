import 'package:flutter/material.dart';
import 'package:ice/app/constants/ui_size.dart';

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
        borderRadius: BorderRadius.circular(UiSize.large),
        color: Colors.white,
      ),
    );
  }
}
