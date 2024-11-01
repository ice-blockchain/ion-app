// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';

class StoryProgressBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0.s, vertical: 8.0.s),
      color: Colors.black,
      child: Row(
        children: List.generate(totalStories, (index) {
          return Expanded(
            child: _ProgressSegmentController(
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

class _ProgressSegmentController extends HookWidget {
  const _ProgressSegmentController({
    required this.isActive,
    required this.isCurrent,
    required this.onCompleted,
    this.margin,
  });

  final bool isActive;
  final bool isCurrent;
  final VoidCallback onCompleted;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
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
