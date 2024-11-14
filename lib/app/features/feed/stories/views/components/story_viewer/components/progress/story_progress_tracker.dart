// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/video_player_provider.dart';
import 'package:ion/app/features/feed/stories/data/models/models.dart';
import 'package:ion/app/features/feed/stories/hooks/use_story_progress.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/progress/progress.dart';

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

    useEffect(
      () {
        if (storyProgress.isCompleted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              onCompleted();
            }
          });
        }
        return null;
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
