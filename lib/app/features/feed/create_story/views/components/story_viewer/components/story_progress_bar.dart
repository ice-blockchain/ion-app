// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/video_player_provider.dart';
import 'package:ion/app/features/feed/create_story/data/models/story.dart';

class StoryProgressBar extends ConsumerWidget {
  const StoryProgressBar({
    required this.stories,
    required this.currentStoryIndex,
    required this.onStoryCompleted,
    super.key,
  });

  final List<Story> stories;
  final int currentStoryIndex;
  final VoidCallback onStoryCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.s),
      child: Row(
        children: stories.asMap().entries.map((entry) {
          final index = entry.key;
          return Expanded(
            child: _ProgressSegmentController(
              story: entry.value,
              isActive: index <= currentStoryIndex,
              isCurrent: index == currentStoryIndex,
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressRef = useRef<double>(0);
    final isCompletedRef = useRef(false);
    final progress = useState<double>(0);
    final animationController = useAnimationController(
      duration: const Duration(seconds: 5),
    );

    final videoController = story is VideoStory
        ? ref.watch(
            videoControllerProvider(
              story.data.contentUrl,
              autoPlay: isCurrent,
            ),
          )
        : null;

    useEffect(
      () {
        if (!isCurrent) {
          progress.value = 0.0;
          isCompletedRef.value = false;
          return null;
        }

        void handleProgress() {
          if (story is VideoStory && videoController != null) {
            if (!videoController.value.isInitialized) return;

            final position = videoController.value.position;
            final duration = videoController.value.duration;

            if (duration.inMilliseconds > 0) {
              final currentProgress =
                  (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
              progressRef.value = currentProgress;
              progress.value = currentProgress;
              isCompletedRef.value = currentProgress >= 1.0;
            }
          } else {
            progressRef.value = animationController.value;
            progress.value = animationController.value;
            isCompletedRef.value = animationController.value >= 1.0;
          }

          if (isCompletedRef.value) {
            onCompleted();
          }
        }

        if (story is VideoStory) {
          if (videoController != null) {
            videoController.addListener(handleProgress);
            if (isCurrent) {
              videoController.play();
            }
            return () {
              videoController.removeListener(handleProgress);
            };
          }
        } else {
          animationController
            ..reset()
            ..forward()
            ..addListener(handleProgress);

          return () => animationController.removeListener(handleProgress);
        }
        return null;
      },
      [isCurrent, videoController, story],
    );

    return _ProgressSegment(
      isActive: isActive,
      storyProgress: isActive ? progress.value : 0.0,
      margin: margin,
    );
  }
}

class _ProgressSegment extends StatelessWidget {
  const _ProgressSegment({
    required this.isActive,
    required this.storyProgress,
    this.margin,
  });

  final bool isActive;
  final double storyProgress;
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
        widthFactor: isActive ? storyProgress : 0.0,
        child: Container(
          color: context.theme.appColors.onPrimaryAccent,
        ),
      ),
    );
  }
}
