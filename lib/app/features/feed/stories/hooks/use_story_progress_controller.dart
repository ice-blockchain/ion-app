// SPDX-License-Identifier: ice License 1.0

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/hooks/use_story_image_progress.dart';
import 'package:ion/app/features/feed/stories/hooks/use_story_video_progress.dart';

class StoryProgressControllerResult {
  StoryProgressControllerResult({
    required this.mediaType,
    this.imageController,
    this.videoController,
  });

  final AnimationController? imageController;
  final CachedVideoPlayerPlusController? videoController;
  final MediaType mediaType;
}

StoryProgressControllerResult useStoryProgressController({
  required WidgetRef ref,
  required ModifiablePostEntity post,
  required bool isCurrent,
  required bool isPaused,
  required VoidCallback onCompleted,
}) {
  final media = post.data.primaryMedia;
  final mediaType = media?.mediaType ?? MediaType.unknown;

  final isImage = (mediaType == MediaType.image);
  final isVideo = (mediaType == MediaType.video);

  final imageResult = useImageStoryProgress(
    isImage: isImage,
    storyId: post.id,
    isCurrent: isCurrent,
    isPaused: isPaused,
    onCompleted: onCompleted,
    ref: ref,
  );

  final videoUrl = media?.url ?? '';
  final videoResult = useVideoStoryProgress(
    ref: ref,
    isVideo: isVideo,
    authorPubkey: post.masterPubkey,
    videoUrl: videoUrl,
    isCurrent: isCurrent,
    isPaused: isPaused,
    onCompleted: onCompleted,
  );

  return StoryProgressControllerResult(
    mediaType: mediaType,
    imageController: isImage ? imageResult.controller : null,
    videoController: isVideo ? videoResult : null,
  );
}
