// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/card/rounded_card.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';

class CreateRecoveryKeyLoadingState extends StatelessWidget {
  const CreateRecoveryKeyLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final recoveryItemHeight = 89.0.s;
    final warningItemHeight = 61.0.s;
    final buttonHeight = 56.0.s;
    final smallSeparatorHeight = 12.0.s;
    final largeSeparatorHeight = 20.0.s;

    return ScreenSideOffset.large(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SkeletonItem(height: recoveryItemHeight),
          SizedBox(height: smallSeparatorHeight),
          _SkeletonItem(height: recoveryItemHeight),
          SizedBox(height: smallSeparatorHeight),
          _SkeletonItem(height: recoveryItemHeight),
          SizedBox(height: largeSeparatorHeight),
          _SkeletonItem(height: warningItemHeight),
          SizedBox(height: largeSeparatorHeight),
          _SkeletonItem(height: buttonHeight),
        ],
      ),
    );
  }
}

class _SkeletonItem extends StatelessWidget {
  const _SkeletonItem({
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return RoundedCard.outlined(
      child: SizedBox(height: height),
    );
  }
}
