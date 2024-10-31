// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_story/data/models/story.dart';

class StoryProgressBar extends ConsumerWidget {
  const StoryProgressBar({
    required this.totalStories,
    required this.currentIndex,
    required this.onStoryCompleted,
    super.key,
  });

  final int totalStories;
  final int currentIndex;
  final VoidCallback onStoryCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenSideOffset.small(
      child: Row(
        children: List.generate(totalStories, (index) {
          return Expanded(
            child: _ProgressSegmentController(
              story: null,
              isActive: index <= currentIndex,
              isCurrent: index == currentIndex,
              onCompleted: onStoryCompleted,
              margin: index > 0 ? EdgeInsets.only(left: 4.0.s) : null,
            ),
          );
        }),
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

  final Story? story;
  final bool isActive;
  final bool isCurrent;
  final VoidCallback onCompleted;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = useState<double>(0);

    final animationController = useAnimationController(
      duration: const Duration(seconds: 5),
    );

    useEffect(
      () {
        if (isCurrent && isActive) {
          void listener() {
            progress.value = animationController.value;
            if (animationController.isCompleted) {
              onCompleted();
            }
          }

          animationController
            ..addListener(listener)
            ..forward(from: 0);

          return () {
            animationController
              ..removeListener(listener)
              ..reset();
          };
        } else {
          animationController.reset();
        }
        return null;
      },
      [isCurrent, isActive],
    );

    return _ProgressSegment(
      isActive: isActive,
      storyProgress: progress.value,
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
