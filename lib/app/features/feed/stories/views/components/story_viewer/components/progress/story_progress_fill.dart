// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class StoryProgressFill extends StatelessWidget {
  const StoryProgressFill({
    required this.isActive,
    required this.storyProgress,
    super.key,
  });

  final bool isActive;
  final double storyProgress;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: isActive ? storyProgress : 0.0,
      child: ColoredBox(
        color: context.theme.appColors.onPrimaryAccent,
      ),
    );
  }
}
