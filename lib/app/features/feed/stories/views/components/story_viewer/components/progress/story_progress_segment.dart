// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/progress/story_progress_fill.dart';
import 'package:ion/app/features/video/views/components/video_progress.dart';
import 'package:ion/app/features/video/views/components/video_slider.dart';
import 'package:video_player/video_player.dart';

class StoryProgressSegment extends StatelessWidget {
  const StoryProgressSegment({
    required this.mediaType,
    required this.isCurrent,
    required this.isPreviousStory,
    required this.imageController,
    required this.videoController,
    super.key,
    this.margin,
  });

  const StoryProgressSegment.placeholder({
    required this.isCurrent,
    required this.isPreviousStory,
    this.margin,
    super.key,
  })  : mediaType = MediaType.image,
        imageController = null,
        videoController = null;

  final bool isCurrent;
  final bool isPreviousStory;
  final EdgeInsetsGeometry? margin;

  final AnimationController? imageController;
  final VideoPlayerController? videoController;
  final MediaType mediaType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2.0.s,
      margin: margin,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: context.theme.appColors.onPrimaryAccent.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(1.0.s),
      ),
      child: _ProgressContent(
        isCurrent: isCurrent,
        isPreviousStory: isPreviousStory,
        imageController: imageController,
        mediaType: mediaType,
        videoController: videoController,
      ),
    );
  }
}

class _ProgressContent extends StatelessWidget {
  const _ProgressContent({
    required this.isCurrent,
    required this.isPreviousStory,
    required this.imageController,
    required this.mediaType,
    required this.videoController,
  });

  final bool isCurrent;
  final bool isPreviousStory;
  final AnimationController? imageController;
  final VideoPlayerController? videoController;
  final MediaType mediaType;

  @override
  Widget build(BuildContext context) {
    const emptyProgress = StoryProgressFill(isActive: false, storyProgress: 0);
    const fullProgress = StoryProgressFill(isActive: true, storyProgress: 1);

    if (isPreviousStory) return fullProgress;
    if (!isCurrent) return emptyProgress;

    if (imageController == null && videoController == null) {
      return emptyProgress;
    }

    switch (mediaType) {
      case MediaType.image:
        return AnimatedBuilder(
          animation: imageController!,
          builder: (context, child) {
            final progressValue = imageController!.value.clamp(0.0, 1.0);
            return StoryProgressFill(
              isActive: true,
              storyProgress: progressValue,
            );
          },
        );

      case MediaType.video:
        final vidCtrl = videoController;

        if (vidCtrl == null) {
          return const StoryProgressFill(isActive: true, storyProgress: 0);
        }

        return VideoProgress(
          controller: vidCtrl,
          builder: (context, position, duration) {
            if (duration.inMilliseconds <= 0) {
              return const StoryProgressFill(isActive: true, storyProgress: 0);
            }

            return VideoSlider(
              duration: duration,
              position: position,
              onChangeStart: (_) => vidCtrl.pause(),
              onChangeEnd: (_) => vidCtrl.play(),
              onChanged: (_) {},
            );
          },
        );

      case MediaType.audio || MediaType.unknown:
        return emptyProgress;
    }
  }
}
