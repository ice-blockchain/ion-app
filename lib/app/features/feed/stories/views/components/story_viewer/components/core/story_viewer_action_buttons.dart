// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/providers/mute_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/providers/counters/like_reaction_provider.c.dart';
import 'package:ion/app/features/feed/providers/counters/likes_notifier.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/components.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class StoryViewerActionButtons extends ConsumerWidget {
  const StoryViewerActionButtons({
    required this.post,
    required this.bottomPadding,
    super.key,
  });

  final ModifiablePostEntity post;
  final double bottomPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shareColor = context.theme.appColors.onPrimaryAccent;

    return PositionedDirectional(
      bottom: bottomPadding,
      end: 16.0.s,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SoundButton(post: post),
          SizedBox(height: 16.0.s),
          StoryControlButton(
            borderRadius: 16.0.s,
            iconPadding: 8.0.s,
            icon: Assets.svg.iconBlockShare.icon(
              color: shareColor,
              size: 20.0.s,
            ),
            onPressed: () async {
              ref.read(storyPauseControllerProvider.notifier).paused = true;

              await ShareViaMessageModalRoute(eventReference: post.toEventReference().encode())
                  .push<void>(context);

              ref.read(storyPauseControllerProvider.notifier).paused = false;
            },
          ),
          SizedBox(height: 16.0.s),
          _LikeButton(post: post),
        ],
      ),
    );
  }
}

class _SoundButton extends ConsumerWidget {
  const _SoundButton({
    required this.post,
  });

  final ModifiablePostEntity post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final media = post.data.primaryMedia;

    if (media == null || media.mediaType != MediaType.video) {
      return const SizedBox.shrink();
    }

    final muteColor = context.theme.appColors.onPrimaryAccent;
    final isMuted = ref.watch(globalMuteProvider);

    return StoryControlButton(
      borderRadius: 16.0.s,
      iconPadding: 8.0.s,
      icon: isMuted
          ? Assets.svg.iconChannelMute.icon(
              color: muteColor,
              size: 20.0.s,
            )
          : Assets.svg.iconChannelUnmute.icon(
              color: muteColor,
              size: 20.0.s,
            ),
      onPressed: () {
        HapticFeedback.lightImpact();
        ref.read(globalMuteProvider.notifier).toggle();
      },
    );
  }
}

class _LikeButton extends ConsumerWidget {
  const _LikeButton({required this.post});

  final ModifiablePostEntity post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventReference = post.toEventReference();
    final isLiked = ref.watch(isLikedProvider(eventReference));

    final appColors = context.theme.appColors;
    final color = isLiked ? appColors.attentionRed : appColors.onPrimaryAccent;
    final icon = isLiked ? Assets.svg.iconVideoLikeOn : Assets.svg.iconVideoLikeOff;

    ref.displayErrors(likesNotifierProvider(eventReference));

    return StoryControlButton(
      icon: icon.icon(
        color: color,
        size: 20.0.s,
      ),
      borderRadius: 16.0.s,
      iconPadding: 8.0.s,
      onPressed: () {
        HapticFeedback.lightImpact();
        ref.read(likesNotifierProvider(eventReference).notifier).toggle();
      },
    );
  }
}
