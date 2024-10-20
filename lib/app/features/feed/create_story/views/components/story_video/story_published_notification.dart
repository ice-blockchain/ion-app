// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/effects/slide_in_out_effects.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_story/providers/story_camera_provider.dart';
import 'package:ion/generated/assets.gen.dart';

class StoryPublishedNotification extends ConsumerWidget {
  const StoryPublishedNotification({required this.height, super.key});

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isStoryPublished = ref.watch(
      storyCameraControllerProvider.select((state) => state.isStoryPublished),
    );

    return Animate(
      effects: topSlideInOutEffects,
      onComplete: (controller) =>
          ref.read(storyCameraControllerProvider.notifier).resetStoryPublished(),
      autoPlay: isStoryPublished,
      child: SizedBox(
        height: height,
        child: ColoredBox(
          color: context.theme.appColors.primaryAccent,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0.s),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.svg.iconBlockCheckboxwhiteOn.icon(
                  color: context.theme.appColors.onPrimaryAccent,
                ),
                SizedBox(width: 8.0.s),
                Text(
                  context.i18n.story_has_been_posted,
                  style: context.theme.appTextThemes.body2.copyWith(
                    color: context.theme.appColors.onPrimaryAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
