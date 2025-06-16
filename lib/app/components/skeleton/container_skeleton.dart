// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';

class ContainerSkeleton extends StatelessWidget {
  const ContainerSkeleton({
    required this.width,
    required this.height,
    this.margin,
    super.key,
    this.skeletonBaseColor,
  });

  final double width;
  final double height;
  final EdgeInsetsGeometry? margin;
  final Color? skeletonBaseColor;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      baseColor: skeletonBaseColor,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: context.theme.appColors.secondaryText,
          borderRadius: BorderRadius.circular(16.0.s),
        ),
      ),
    );
  }
}
