// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/data/models/models.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/components.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/generated/assets.gen.dart';

class StoryViewerActionButtons extends ConsumerWidget {
  const StoryViewerActionButtons({
    required this.story,
    required this.bottomPadding,
    super.key,
  });

  final Story story;
  final double bottomPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      bottom: bottomPadding,
      right: 16.0.s,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SoundButton(story: story),
          SizedBox(height: 16.0.s),
          StoryControlButton(
            borderRadius: 16.0.s,
            iconPadding: 8.0.s,
            icon: Assets.svg.iconBlockShare.icon(
              color: context.theme.appColors.onPrimaryAccent,
              size: 20.0.s,
            ),
            onPressed: () async {
              ref.read(storyPauseControllerProvider.notifier).paused = true;

              await StoryContactsShareRoute().push<void>(context);

              ref.read(storyPauseControllerProvider.notifier).paused = false;
            },
          ),
          SizedBox(height: 16.0.s),
          _LikeButton(story: story),
        ],
      ),
    );
  }
}

class _SoundButton extends ConsumerWidget {
  const _SoundButton({
    required this.story,
  });

  final Story story;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return story.maybeWhen(
      video: (data, muteState, likeState) => StoryControlButton(
        borderRadius: 16.0.s,
        iconPadding: 8.0.s,
        icon: muteState == MuteState.muted
            ? Assets.svg.iconChannelMute.icon(
                color: context.theme.appColors.onPrimaryAccent,
                size: 20.0.s,
              )
            : Assets.svg.iconChannelUnmute.icon(
                color: context.theme.appColors.onPrimaryAccent,
                size: 20.0.s,
              ),
        onPressed: () => ref.read(storyViewingControllerProvider.notifier).toggleMute(data.id),
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _LikeButton extends ConsumerWidget {
  const _LikeButton({
    required this.story,
  });

  final Story story;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLiked = story.likeState == LikeState.liked;
    final icon = isLiked ? Assets.svg.iconVideoLikeOn : Assets.svg.iconVideoLikeOff;
    final color =
        isLiked ? context.theme.appColors.attentionRed : context.theme.appColors.onPrimaryAccent;

    return StoryControlButton(
      icon: icon.icon(
        color: color,
        size: 20.0.s,
      ),
      borderRadius: 16.0.s,
      iconPadding: 8.0.s,
      onPressed: () => ref.read(storyViewingControllerProvider.notifier).toggleLike(story.post.id),
    );
  }
}
