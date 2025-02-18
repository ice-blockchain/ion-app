// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/hooks/use_story_progress.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/progress/progress.dart';
import 'package:ion/app/hooks/use_on_init.dart';

class StoryProgressTracker extends HookConsumerWidget {
  const StoryProgressTracker({
    required this.post,
    required this.isActive,
    required this.isCurrent,
    required this.isPreviousStory,
    required this.onCompleted,
    this.margin,
    super.key,
  });

  final ModifiablePostEntity post;
  final bool isActive;
  final bool isCurrent;
  final bool isPreviousStory;
  final VoidCallback onCompleted;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaused = ref.watch(storyPauseControllerProvider);

    final firstMedia = post.data.primaryMedia;
    final videoController = (firstMedia != null && firstMedia.mediaType == MediaType.video)
        ? ref.watch(
            videoControllerProvider(
              firstMedia.url,
              autoPlay: isCurrent,
            ),
          )
        : null;

    final storyProgress = useStoryProgress(
      post: post,
      isCurrent: isCurrent,
      isPaused: isPaused,
      videoController: videoController,
    );

    useOnInit(
      () {
        if (storyProgress.isCompleted) {
          onCompleted();
        }
      },
      [storyProgress.isCompleted],
    );

    return StoryProgressSegment(
      isActive: isActive,
      storyProgress: isActive ? storyProgress.progress : 0.0,
      isPreviousStory: isPreviousStory,
      margin: margin,
    );
  }
}
