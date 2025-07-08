// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.r.dart';
import 'package:ion/app/features/feed/stories/providers/user_stories_provider.r.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/progress/progress.dart';

class StoryProgressBarContainer extends ConsumerWidget {
  const StoryProgressBarContainer({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyState = ref.watch(storyViewingControllerProvider(pubkey));
    final currentStoryIndex = storyState.currentStoryIndex;
    final stories = ref.watch(userStoriesProvider(storyState.currentUserPubkey))?.toList() ?? [];

    if (stories.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.s),
      child: Row(
        children: stories.asMap().entries.map((storyEntry) {
          final index = storyEntry.key;
          final mediaType = storyEntry.value.data.primaryMedia?.mediaType ?? MediaType.unknown;
          final isVideo = mediaType == MediaType.video;
          return Expanded(
            child: StoryProgressTracker(
              key: ValueKey(storyEntry.value.id),
              post: storyEntry.value,
              isCurrent: index == currentStoryIndex,
              isPreviousStory: index < currentStoryIndex,
              onCompleted: isVideo
                  ? null
                  : () => ref
                      .read(storyViewingControllerProvider(pubkey).notifier)
                      .advance(stories: stories, onClose: () => context.pop()),
              margin: index > 0 ? EdgeInsetsDirectional.only(start: 4.0.s) : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}
