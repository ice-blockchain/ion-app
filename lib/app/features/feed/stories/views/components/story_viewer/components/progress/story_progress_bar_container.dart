// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/data/models/story.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/progress/progress.dart';

class StoryProgressBarContainer extends ConsumerWidget {
  const StoryProgressBarContainer({
    required this.stories,
    required this.currentStoryIndex,
    required this.onStoryCompleted,
    required this.isPaused,
    super.key,
  });

  final List<Story> stories;
  final int currentStoryIndex;
  final VoidCallback onStoryCompleted;
  final bool isPaused;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.s),
      child: Row(
        children: stories.asMap().entries.map((entry) {
          final index = entry.key;
          return Expanded(
            child: StoryProgressTracker(
              story: entry.value,
              isActive: index <= currentStoryIndex,
              isCurrent: index == currentStoryIndex,
              isPreviousStory: index < currentStoryIndex,
              isPaused: isPaused,
              onCompleted: onStoryCompleted,
              margin: index > 0 ? EdgeInsets.only(left: 4.0.s) : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}
