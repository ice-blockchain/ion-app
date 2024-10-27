// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_story/data/models/story.dart';
import 'package:ion/app/features/feed/create_story/hooks/use_story_progress.dart';
import 'package:ion/app/features/feed/create_story/providers/story_viewing_provider.dart';

typedef OnStoryCompleted = void Function();

class StoryProgressSegments extends ConsumerWidget {
  const StoryProgressSegments({
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
    final progress = useStoryProgress(
      ref,
      story: story,
      isCurrent: isCurrent,
      onCompleted: onCompleted,
      context: context,
    );

    return _ProgressSegment(
      isActive: isActive,
      progress: isActive ? progress : 0.0,
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
