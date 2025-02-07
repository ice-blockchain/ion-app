// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/viewed_stories_provider.c.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/plus_icon.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/user_story_list_item.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class CurrentUserStoryListItem extends HookConsumerWidget {
  const CurrentUserStoryListItem({
    required this.pubkey,
    required this.gradient,
    super.key,
  });

  final String pubkey;
  final Gradient? gradient;

  static double get plusSize => 18.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserMetadata = ref.watch(currentUserMetadataProvider);
    final userStories = ref.watch(filteredStoriesByPubkeyProvider(pubkey));
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

        return PermissionAwareWidget(
          permissionType: Permission.camera,
          onGranted: () => hasStories
              ? StoryViewerRoute(pubkey: pubkey).push<void>(context)
              : StoryRecordRoute().push<void>(context),
          requestDialog: const PermissionRequestSheet(permission: Permission.camera),
          settingsDialog: SettingsRedirectSheet.fromType(context, Permission.camera),
          builder: (context, onPressed) {
            return Hero(
              tag: 'story-$pubkey',
              child: Material(
                color: Colors.transparent,
                child: StoryItemView(
                  imageUrl: userMetadata.data.picture,
                  name: context.i18n.common_you,
                  gradient: hasStories ? gradient : null,
                  isViewed: allStoriesViewed,
                  onTap: onPressed,
                  child: !hasStories
                      ? Positioned(
                          bottom: -plusSize / 2,
                          child: PlusIcon(size: plusSize),
                        )
                      : null,
                ),
              ),
            );
          },
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
