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
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final fillWidth = isActive ? maxWidth * storyProgress : 0.0;

        return Stack(
          children: [
            AnimatedContainer(
              duration: Duration.zero,
              width: fillWidth,
              height: constraints.maxHeight,
              decoration: BoxDecoration(
                color: context.theme.appColors.onPrimaryAccent,
              ),
            ),
          ],
        );
      },
    );
  }
}
