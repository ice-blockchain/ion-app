// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/ion_connect_avatar/ion_connect_avatar.dart';
import 'package:ion/app/features/feed/stories/data/models/stories_references.f.dart';
import 'package:ion/app/features/feed/stories/providers/feed_stories_provider.r.dart';
import 'package:ion/app/features/feed/stories/providers/viewed_stories_provider.r.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_colored_border.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/mock.dart';
import 'package:ion/app/router/app_routes.gr.dart';

final _storyStatusProvider =
    Provider.family<({bool hasStories, bool allStoriesViewed}), String>((ref, pubkey) {
  final userStory = ref.watch(feedStoriesByPubkeyProvider(pubkey, showOnlySelectedUser: true));
  final storiesReferences = StoriesReferences(userStory.map((e) => e.story.toEventReference()));
  final viewedStories = ref.watch(viewedStoriesControllerProvider(storiesReferences));

  final hasStories = userStory.isNotEmpty;
  final allStoriesViewed = viewedStories.isNotEmpty;

  return (hasStories: hasStories, allStoriesViewed: allStoriesViewed);
});

class StoryColoredProfileAvatar extends HookConsumerWidget {
  const StoryColoredProfileAvatar({
    required this.pubkey,
    required this.size,
    this.borderRadius,
    this.fit,
    this.imageUrl,
    this.imageWidget,
    this.defaultAvatar,
    this.useRandomGradient = false,
    super.key,
  });

  final String pubkey;
  final double size;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? fit;
  final String? imageUrl;
  final Widget? imageWidget;
  final Widget? defaultAvatar;
  final bool useRandomGradient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyStatus = ref.watch(_storyStatusProvider(pubkey));
    final hasStories = storyStatus.hasStories;
    final allStoriesViewed = storyStatus.allStoriesViewed;

    final gradient = useMemoized(
      () {
        if (!hasStories) {
          return null;
        }

        return useRandomGradient
            ? storyBorderGradients[Random().nextInt(storyBorderGradients.length)]
            : storyBorderGradients.first;
      },
      [hasStories, useRandomGradient],
    );

    Widget avatarWidget;

    if (!hasStories) {
      if (imageUrl != null || imageWidget != null || defaultAvatar != null) {
        avatarWidget = Avatar(
          size: size,
          imageUrl: imageUrl,
          imageWidget: imageWidget,
          defaultAvatar: defaultAvatar,
          borderRadius: borderRadius,
          fit: fit,
        );
      } else {
        avatarWidget = IonConnectAvatar(
          size: size,
          fit: fit,
          pubkey: pubkey,
          borderRadius: borderRadius,
        );
      }
    } else {
      avatarWidget = StoryColoredBorder(
        size: size,
        color: context.theme.appColors.strokeElements,
        gradient: gradient,
        isViewed: allStoriesViewed,
        child: StoryColoredBorder(
          size: size - 4.0.s,
          color: context.theme.appColors.secondaryBackground,
          child: imageUrl != null || imageWidget != null || defaultAvatar != null
              ? Avatar(
                  size: size - 8.0.s,
                  imageUrl: imageUrl,
                  imageWidget: imageWidget,
                  defaultAvatar: defaultAvatar,
                  borderRadius: borderRadius,
                  fit: fit,
                )
              : IonConnectAvatar(
                  size: size - 8.0.s,
                  fit: fit,
                  pubkey: pubkey,
                  borderRadius: borderRadius,
                ),
        ),
      );
    }

    if (hasStories) {
      return GestureDetector(
        onTap: () =>
            StoryViewerRoute(pubkey: pubkey, showOnlySelectedUser: true).push<void>(context),
        child: avatarWidget,
      );
    }

    return avatarWidget;
  }
}
