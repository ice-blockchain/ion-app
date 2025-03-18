// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.theme.appColors.primaryBackground,
      highlightColor: context.theme.appColors.secondaryBackground,
      child: child,
    );
  }
}

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: ListItem(
        constraints: BoxConstraints(
          maxWidth: width ?? double.infinity,
          maxHeight: height ?? double.infinity,
        ),
      ),
    );
  }
}
