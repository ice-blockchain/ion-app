// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';

class NftDetailsLoading extends StatelessWidget {
  const NftDetailsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SkeletonBox(
          width: 170.0.s,
          height: 170.0.s,
        ),
        SizedBox(height: 15.0.s),
        SkeletonBox(height: 68.0.s),
        SizedBox(height: 12.0.s),
        SkeletonBox(height: 82.0.s),
        SizedBox(height: 12.0.s),
        SkeletonBox(height: 42.0.s),
        SizedBox(height: 12.0.s),
        SkeletonBox(height: 42.0.s),
        SizedBox(height: 12.0.s),
        SkeletonBox(height: 42.0.s),
        SizedBox(height: 12.0.s),
        SkeletonBox(height: 56.0.s),
      ],
    );
  }
}
