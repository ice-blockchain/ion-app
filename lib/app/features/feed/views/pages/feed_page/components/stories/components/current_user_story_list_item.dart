// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/stories/providers/feed_stories_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/viewed_stories_provider.c.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/current_user_avatar_with_permission.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/plus_button_with_permission.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';

class CurrentUserStoryListItem extends HookConsumerWidget {
  const CurrentUserStoryListItem({
    required this.pubkey,
    required this.gradient,
    super.key,
  });

  final String pubkey;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserMetadata = ref.watch(currentUserMetadataProvider);
    final userStories = ref.watch(feedStoriesByPubkeyProvider(pubkey));
    final viewedStories = ref.watch(viewedStoriesControllerProvider);
    final hasStories = userStories.isNotEmpty;

    final allStoriesViewed = useMemoized(
      () =>
          hasStories &&
          userStories.first.stories.every((story) => viewedStories.contains(story.id)),
      [userStories, viewedStories],
    );

    return currentUserMetadata.maybeWhen(
      data: (userMetadata) {
        if (userMetadata == null) return const SizedBox.shrink();

        return Material(
          color: Colors.transparent,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              CurrentUserAvatarWithPermission(
                pubkey: pubkey,
                hasStories: hasStories,
                gradient: hasStories ? gradient : null,
                isViewed: allStoriesViewed,
                imageUrl: userMetadata.data.picture,
              ),
              const PlusButtonWithPermission(),
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
