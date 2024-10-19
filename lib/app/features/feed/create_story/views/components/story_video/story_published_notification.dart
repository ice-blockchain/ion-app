import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/create_story/providers/story_camera_provider.dart';
import 'package:ice/generated/assets.gen.dart';

class StoryPublishedNotification extends ConsumerWidget {
  const StoryPublishedNotification({
    required this.maxHeight,
    super.key,
  });

  final double maxHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isStoryPublished = ref.watch(
      storyCameraControllerProvider.select((state) => state.isStoryPublished),
    );

    return Animate(
      effects: [
        SlideEffect(
          begin: Offset(0.0.s, -1.0.s),
          end: Offset.zero,
          duration: 300.ms,
          curve: Curves.easeOut,
        ),
        FadeEffect(
          begin: 0.0.s,
          end: 1.0.s,
          duration: 300.ms,
        ),
        ThenEffect(delay: 5.seconds),
        FadeEffect(
          begin: 1.0.s,
          end: 0.0.s,
          duration: 300.ms,
        ),
        SlideEffect(
          begin: Offset.zero,
          end: Offset(0.0.s, -1.0.s),
          duration: 300.ms,
          curve: Curves.easeIn,
        ),
      ],
      onComplete: (controller) =>
          ref.read(storyCameraControllerProvider.notifier).resetStoryPublished(),
      autoPlay: isStoryPublished,
      child: SizedBox(
        height: maxHeight,
        child: ColoredBox(
          color: context.theme.appColors.primaryAccent,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0.s),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.svg.iconBlockCheckboxOn.icon(
                  color: context.theme.appColors.onPrimaryAccent,
                ),
                SizedBox(width: 12.0.s),
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
