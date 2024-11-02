// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/progress_bar/story_progress_fill.dart';

class StoryProgressSegment extends StatelessWidget {
  const StoryProgressSegment({
    required this.isActive,
    required this.storyProgress,
    this.margin,
    super.key,
  });

  final bool isActive;
  final double storyProgress;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4.0.s,
      margin: margin,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: context.theme.appColors.onPrimaryAccent.withOpacity(0.3),
        borderRadius: BorderRadius.circular(1.0.s),
      ),
      child: StoryProgressFill(
        isActive: isActive,
        storyProgress: storyProgress,
      ),
    );
  }
}
