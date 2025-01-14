// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/progress/progress.dart';

class StoryProgressSegment extends StatelessWidget {
  const StoryProgressSegment({
    required this.isActive,
    required this.storyProgress,
    required this.isPreviousStory,
    this.margin,
    super.key,
  });

  final bool isActive;
  final double storyProgress;
  final bool isPreviousStory;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4.0.s,
      margin: margin,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: context.theme.appColors.onPrimaryAccent.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(1.0.s),
      ),
      child: StoryProgressFill(
        isActive: isActive,
        storyProgress: isPreviousStory ? 1.0 : storyProgress,
      ),
    );
  }
}
