// SPDX-License-Identifier: ice License 1.0
// Updated StoryProgressTracker using the improved useStoryProgressController hook.

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';
import 'package:ion/app/features/feed/stories/hooks/use_story_progress_controller.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.r.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/progress/story_progress_segment.dart';

class StoryProgressTracker extends HookConsumerWidget {
  const StoryProgressTracker({
    required this.post,
    required this.isCurrent,
    required this.isPreviousStory,
    required this.onCompleted,
    this.margin,
    super.key,
  });

  final ModifiablePostEntity post;
  final bool isCurrent;
  final bool isPreviousStory;
  final VoidCallback? onCompleted;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaused = ref.watch(storyPauseControllerProvider);

    final progressController = useStoryProgressController(
      ref: ref,
      post: post,
      isCurrent: isCurrent,
      isPaused: isPaused,
      onCompleted: onCompleted ?? () {},
    );

    return StoryProgressSegment(
      key: ValueKey(post.id),
      post: post,
      isCurrent: isCurrent,
      isPreviousStory: isPreviousStory,
      margin: margin,
      mediaType: progressController.mediaType,
      imageController: progressController.imageController,
      videoController: progressController.videoController,
    );
  }
}
