// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/hooks/use_story_completion.dart';
import 'package:ion/app/features/feed/stories/hooks/use_story_image_progress.dart';
import 'package:ion/app/features/feed/stories/hooks/use_story_pause.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/progress/story_progress_segment.dart';

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

    final media = post.data.primaryMedia;
    final isVideo = media != null && media.mediaType == MediaType.video;

    final videoController =
        isVideo ? ref.watch(videoControllerProvider(media.url, autoPlay: isCurrent)) : null;

    final (:imageController, :mediaType) = useStoryImageProgress(
      post: post,
      isCurrent: isCurrent,
      isPaused: isPaused,
    );

    useStoryCompletion(
      imageController: imageController,
      videoController: videoController,
      onCompleted: onCompleted,
    );

    useStoryPause(
      imageController: imageController,
      videoController: videoController,
      isPaused: isPaused,
    );

    return StoryProgressSegment(
      post: post,
      isActive: isActive,
      isPreviousStory: isPreviousStory,
      margin: margin,
      mediaType: mediaType,
      imageController: imageController,
      videoController: videoController,
    );
  }
}
