// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/progress/progress.dart';

class StoryProgressBarContainer extends ConsumerWidget {
  const StoryProgressBarContainer({
    required this.posts,
    required this.currentStoryIndex,
    required this.onStoryCompleted,
    super.key,
  });

  final List<PostEntity> posts;
  final int currentStoryIndex;
  final VoidCallback onStoryCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.s),
      child: Row(
        children: posts.asMap().entries.map((post) {
          final index = post.key;
          return Expanded(
            child: StoryProgressTracker(
              post: post.value,
              isActive: index <= currentStoryIndex,
              isCurrent: index == currentStoryIndex,
              isPreviousStory: index < currentStoryIndex,
              onCompleted: onStoryCompleted,
              margin: index > 0 ? EdgeInsets.only(left: 4.0.s) : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}
