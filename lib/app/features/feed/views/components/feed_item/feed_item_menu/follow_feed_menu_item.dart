// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/views/pages/unfollow_user_page.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_menu/feed_item_menu_item.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class FollowFeedMenuItem extends ConsumerWidget {
  const FollowFeedMenuItem({required this.userMetadata, super.key});

  final UserMetadataEntity userMetadata;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final following = ref.watch(isCurrentUserFollowingSelectorProvider(userMetadata.pubkey));
    return FeedItemMenuItem(
      label: following
          ? context.i18n.post_menu_unfollow_nickname(userMetadata.data.name)
          : context.i18n.post_menu_follow_nickname(userMetadata.data.name),
      icon: Assets.svg.iconFollowuser.icon(
        size: 20.0.s,
        color: following
            ? context.theme.appColors.primaryAccent
            : context.theme.appColors.quaternaryText,
      ),
      onPressed: () {
        if (following) {
          showSimpleBottomSheet<void>(
            context: context,
            child: UnfollowUserModal(pubkey: userMetadata.pubkey),
          );
        } else {
          ref.read(followListManagerProvider.notifier).toggleFollow(userMetadata.pubkey);
        }
      },
    );
  }
}
