// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/progress/progress.dart';

class StoryProgressBarContainer extends ConsumerWidget {
  const StoryProgressBarContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyState = ref.watch(storyViewingControllerProvider);
    final userStories = ref.watch(storyViewingControllerProvider.select((s) => s.userStories));
    final currentStoryIndex =
        ref.watch(storyViewingControllerProvider.select((s) => s.currentStoryIndex));
    final currentUserIndex =
        ref.watch(storyViewingControllerProvider.select((s) => s.currentUserIndex));

    final posts = userStories.isNotEmpty ? userStories[currentUserIndex].stories : null;

    if (posts?.isEmpty ?? true) {
      return const SizedBox();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.s),
      child: Row(
        children: posts!.asMap().entries.map((post) {
          final index = post.key;
          return Expanded(
            child: StoryProgressTracker(
              key: ValueKey(post.value.id),
              post: post.value,
              isCurrent: index == currentStoryIndex,
              isPreviousStory: index < currentStoryIndex,
              onCompleted: () {
                final notifier = ref.read(storyViewingControllerProvider.notifier);

                if (storyState.hasNextStory) {
                  notifier.moveToNextStory();
                } else if (storyState.hasNextUser) {
                  notifier.moveToNextUser();
                } else {
                  context.pop();
                }
              },
              margin: index > 0 ? EdgeInsets.only(left: 4.0.s) : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}
