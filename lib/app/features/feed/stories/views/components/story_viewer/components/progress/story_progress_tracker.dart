// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/hooks/use_story_completion.dart';
import 'package:ion/app/features/feed/stories/hooks/use_story_image_progress.dart';
import 'package:ion/app/features/feed/stories/hooks/use_story_pause.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/progress/story_progress_segment.dart';
import 'package:ion/app/services/logger/logger.dart';

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
  final VoidCallback onCompleted;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaused = ref.watch(storyPauseControllerProvider);

    final media = post.data.primaryMedia;
    final isVideo = media != null && media.mediaType == MediaType.video;

    final videoController =
        isVideo ? ref.watch(videoControllerProvider(media.url, autoPlay: isCurrent)) : null;

    final isVideoLoading =
        isVideo && isCurrent && (videoController == null || !videoController.value.isInitialized);

    Logger.info('StoryProgressTracker: post.id=${post.id}, isCurrent=$isCurrent, '
        'isVideo=$isVideo, videoControllerInitialized=${videoController?.value.isInitialized}, '
        'isVideoLoading=$isVideoLoading');

    useEffect(
      () {
        Logger.info('StoryProgressTracker: isCurrent changed: $isCurrent for post ${post.id}');
        return null;
      },
      [isCurrent],
    );

    useEffect(
      () {
        if (isVideo && videoController != null) {
          Logger.info('VideoController status for post ${post.id}: '
              'initialized=${videoController.value.isInitialized}, '
              'isPlaying=${videoController.value.isPlaying}, '
              'position=${videoController.value.position}, '
              'duration=${videoController.value.duration}');
        }
        return null;
      },
      [videoController?.value],
    );

    final (:imageController, :mediaType) = useStoryImageProgress(
      post: post,
      isCurrent: isCurrent && !isVideoLoading,
      isPaused: isPaused,
    );

    useStoryCompletion(
      isCurrent: isCurrent,
      imageController: imageController,
      videoController: videoController,
      onCompleted: isVideoLoading ? () {} : onCompleted,
    );

    if (isVideoLoading) {
      Logger.info('Completion hook will be ignored for post ${post.id} - video is still loading');
    }

    useStoryPause(
      imageController: imageController,
      videoController: videoController,
      isPaused: isPaused,
    );

    return StoryProgressSegment(
      key: ValueKey(post.id),
      post: post,
      isCurrent: isCurrent,
      isPreviousStory: isPreviousStory,
      margin: margin,
      mediaType: mediaType,
      imageController: imageController,
      videoController: videoController,
    );
  }
}
