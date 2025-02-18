// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/providers/mute_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.c.dart';
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
    return Positioned(
      bottom: bottomPadding,
      right: 16.0.s,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SoundButton(post: post),
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

    final isMuted = ref.watch(globalMuteProvider);

    return StoryControlButton(
      borderRadius: 16.0.s,
      iconPadding: 8.0.s,
      icon: isMuted
          ? Assets.svg.iconChannelMute.icon(
              color: context.theme.appColors.onPrimaryAccent,
              size: 20.0.s,
            )
          : Assets.svg.iconChannelUnmute.icon(
              color: context.theme.appColors.onPrimaryAccent,
              size: 20.0.s,
            ),
      onPressed: () => ref.read(globalMuteProvider.notifier).toggle(),
    );
  }
}

class _LikeButton extends HookConsumerWidget {
  const _LikeButton({required this.post});

  final ModifiablePostEntity post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLiked = useState(false);

    final icon = isLiked.value ? Assets.svg.iconVideoLikeOn : Assets.svg.iconVideoLikeOff;
    final color = isLiked.value
        ? context.theme.appColors.attentionRed
        : context.theme.appColors.onPrimaryAccent;

    return StoryControlButton(
      icon: icon.icon(
        color: color,
        size: 20.0.s,
      ),
      borderRadius: 16.0.s,
      iconPadding: 8.0.s,
      onPressed: () {
        isLiked.value = !isLiked.value;
        ref.read(storyViewingControllerProvider.notifier).toggleLike(post.id);
      },
    );
  }
}
