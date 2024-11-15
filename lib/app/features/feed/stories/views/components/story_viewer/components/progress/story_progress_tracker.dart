// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/video_player_provider.dart';
import 'package:ion/app/features/feed/stories/data/models/models.dart';
import 'package:ion/app/features/feed/stories/hooks/use_story_progress.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/progress/progress.dart';
import 'package:ion/app/hooks/use_on_init.dart';

class StoryProgressTracker extends HookConsumerWidget {
  const StoryProgressTracker({
    required this.story,
    required this.isActive,
    required this.isCurrent,
    required this.isPreviousStory,
    required this.onCompleted,
    this.margin,
    super.key,
  });

  final Story story;
  final bool isActive;
  final bool isCurrent;
  final bool isPreviousStory;
  final VoidCallback onCompleted;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaused = ref.watch(storyPauseControllerProvider);

    final videoController = story.whenOrNull(
      video: (data, _) => ref.watch(
        videoControllerProvider(
          data.contentUrl,
          autoPlay: isCurrent,
        ),
      ),
    );

    final storyProgress = useStoryProgress(
      story: story,
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
