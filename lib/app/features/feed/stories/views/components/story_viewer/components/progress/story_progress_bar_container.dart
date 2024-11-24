// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/progress/progress.dart';

class StoryProgressBarContainer extends ConsumerWidget {
  const StoryProgressBarContainer({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyState = ref.watch(storyViewingControllerProvider(startingPubkey: pubkey));
    final posts = storyState.userStories[storyState.currentUserIndex].stories;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.s),
      child: Row(
        children: posts.asMap().entries.map((post) {
          final index = post.key;
          return Expanded(
            child: StoryProgressTracker(
              post: post.value,
              isActive: index <= storyState.currentStoryIndex,
              isCurrent: index == storyState.currentStoryIndex,
              isPreviousStory: index < storyState.currentStoryIndex,
              onCompleted: () {
                final notifier =
                    ref.read(storyViewingControllerProvider(startingPubkey: pubkey).notifier);

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
