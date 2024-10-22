// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_story/data/models/story.dart';
import 'package:video_player/video_player.dart';

typedef OnStoryCompleted = void Function();

class StoryProgressSegments extends StatelessWidget {
  const StoryProgressSegments({
    required this.stories,
    required this.currentIndex,
    required this.onStoryCompleted,
    super.key,
  });

  final List<Story> stories;
  final int currentIndex;
  final OnStoryCompleted onStoryCompleted;

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: Row(
        children: stories.asMap().entries.map((entry) {
          final index = entry.key;
          final story = entry.value;
          return Expanded(
            child: _ProgressSegmentController(
              story: story,
              isActive: index <= currentIndex,
              isCurrent: index == currentIndex,
              onCompleted: onStoryCompleted,
              margin: index > 0 ? EdgeInsets.only(left: 4.0.s) : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ProgressSegmentController extends HookConsumerWidget {
  const _ProgressSegmentController({
    required this.story,
    required this.isActive,
    required this.isCurrent,
    required this.onCompleted,
    this.margin,
  });

  final Story story;
  final bool isActive;
  final bool isCurrent;
  final VoidCallback onCompleted;
  final EdgeInsetsGeometry? margin;

  static const _imageDuration = Duration(seconds: 5);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController = useAnimationController(duration: _imageDuration);
    final storyProgress = useState<double>(0);
    final videoController = useState<VideoPlayerController?>(null);
    final isDisposed = useState(false);

    useEffect(
      () {
        if (!isCurrent || story is! ImageStory) {
          animationController.reset();
          storyProgress.value = isActive ? 1.0 : 0.0;
          return null;
        }

        animationController
          ..reset()
          ..forward();

        void updateImageProgress() {
          storyProgress.value = animationController.value;
          if (animationController.isCompleted && context.mounted) {
            onCompleted();
          }
        }

        animationController.addListener(updateImageProgress);
        return () => animationController.removeListener(updateImageProgress);
      },
      [isCurrent, story is ImageStory],
    );

    useEffect(
      () {
        void cleanupController() {
          if (videoController.value != null && !isDisposed.value) {
            isDisposed.value = true;
            final controller = videoController.value!;
            videoController.value = null;
            controller
              ..removeListener(() {})
              ..pause()
              ..dispose();
          }
        }

        if (!isCurrent || story is! VideoStory) {
          cleanupController();
          storyProgress.value = isActive ? 1.0 : 0.0;
          return null;
        }

        isDisposed.value = false;

        Future<void> initializeController() async {
          try {
            final controller = VideoPlayerController.networkUrl(
              Uri.parse(story.data.contentUrl),
              videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
            );

            await controller.initialize();
            if (!context.mounted || isDisposed.value) {
              await controller.dispose();
              return;
            }

            videoController.value = controller;

            void updateVideoProgress() {
              if (!context.mounted || isDisposed.value || !controller.value.isInitialized) {
                return;
              }

              final position = controller.value.position;
              final duration = controller.value.duration;

              if (duration.inMilliseconds > 0) {
                storyProgress.value =
                    (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);

                if (position >= duration && context.mounted) {
                  onCompleted();
                }
              }
            }

            controller.addListener(updateVideoProgress);
            if (!isDisposed.value) {
              await controller.play();
            }
          } catch (e) {
            isDisposed.value = true;
          }
        }

        initializeController();

        return cleanupController;
      },
      [isCurrent, story is VideoStory, story.data.id],
    );

    useEffect(
      () => () {
        if (videoController.value != null) {
          isDisposed.value = true;
          final controller = videoController.value!;
          videoController.value = null;
          controller.dispose();
        }
      },
      const [],
    );

    return _ProgressSegment(
      isActive: isActive,
      progress: storyProgress.value,
      margin: margin,
    );
  }
}

class _ProgressSegment extends StatelessWidget {
  const _ProgressSegment({
    required this.isActive,
    required this.progress,
    this.margin,
  });

  final bool isActive;
  final double progress;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4.0.s,
      margin: margin,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: context.theme.appColors.onPrimaryAccent.withOpacity(0.3),
        borderRadius: BorderRadius.circular(1.0.s),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: isActive ? progress : 0.0,
        child: Container(
          color: context.theme.appColors.onPrimaryAccent,
        ),
      ),
    );
  }
}
