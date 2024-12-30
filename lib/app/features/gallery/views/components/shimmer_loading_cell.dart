// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';

class ShimmerLoadingCell extends StatelessWidget {
  const ShimmerLoadingCell({super.key, this.dimension});

  final double? dimension;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: SizedBox.square(
        dimension: dimension ?? 122.0.s,
        child: const DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
