// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/video_player_provider.dart';
import 'package:ion/app/features/feed/create_story/data/models/story.dart';
import 'package:ion/app/features/feed/create_story/hooks/use_image_story_progress.dart';
import 'package:ion/app/features/feed/create_story/hooks/use_video_story_progress.dart';
import 'package:ion/app/features/feed/create_story/providers/story_viewing_provider.dart';
import 'package:ion/app/hooks/use_on_init.dart';

class StoryProgressBar extends ConsumerWidget {
  const StoryProgressBar({
    required this.onStoryCompleted,
    super.key,
  });

  final VoidCallback onStoryCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyState = ref.watch(storyViewingControllerProvider);

    return storyState.maybeMap(
      ready: (ready) => ScreenSideOffset.small(
        child: Row(
          children: ready.stories.asMap().entries.map((entry) {
            final index = entry.key;
            final story = entry.value;
            return Expanded(
              child: _ProgressSegmentController(
                story: story,
                isActive: index <= ready.currentIndex,
                isCurrent: index == ready.currentIndex,
                onCompleted: onStoryCompleted,
                margin: index > 0 ? EdgeInsets.only(left: 4.0.s) : null,
              ),
            );
          }).toList(),
        ),
      ),
      orElse: () => const SizedBox.shrink(),
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
    final videoController = story is VideoStory
        ? ref.watch(
            videoControllerProvider(
              story.data.contentUrl,
              autoPlay: isCurrent,
            ),
          )
        : null;

    final storyProgress = switch (story) {
      ImageStory() => useImageStoryProgress(
          isCurrent: isCurrent,
          duration: const Duration(seconds: 5),
        ),
      VideoStory() => useVideoStoryProgress(
          isCurrent: isCurrent,
          controller: videoController,
        ),
    };

    useOnInit(
      () {
        if (storyProgress.isCompleted) {
          onCompleted();
        }
      },
      [storyProgress.isCompleted],
    );

    return _ProgressSegment(
      isActive: isActive,
      storyProgress: isActive ? storyProgress.progress : 0.0,
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
