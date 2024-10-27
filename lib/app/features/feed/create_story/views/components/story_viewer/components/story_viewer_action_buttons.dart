// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_story/data/models/story.dart';
import 'package:ion/app/features/feed/create_story/providers/story_viewing_provider.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_capture/story_control_button.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/generated/assets.gen.dart';

class StoryViewerActionButtons extends ConsumerWidget {
  const StoryViewerActionButtons({
    required this.story,
    super.key,
  });

  final Story story;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SoundButton(story: story),
        SizedBox(height: 16.0.s),
        StoryControlButton(
          icon: Assets.svg.iconBlockShare.icon(
            color: context.theme.appColors.onPrimaryAccent,
          ),
          onPressed: () {
            StoryContactsShareRoute().push<void>(context);
          },
        ),
        SizedBox(height: 16.0.s),
        _LikeButton(story: story),
      ],
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
      video: (data, muteState) => StoryControlButton(
        icon: muteState == MuteState.muted
            ? Assets.svg.iconChannelUnmute.icon()
            : Assets.svg.iconChannelMute.icon(),
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
    final isLiked = story.data.likeState == LikeState.liked;
    final icon = isLiked ? Assets.svg.iconVideoLikeOn : Assets.svg.iconVideoLikeOff;
    final color = isLiked ? Colors.red : context.theme.appColors.onPrimaryAccent;

    return StoryControlButton(
      icon: icon.icon(color: color),
      onPressed: () => ref.read(storyViewingControllerProvider.notifier).toggleLike(story.data.id),
    );
  }
}
