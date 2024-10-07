// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/skeleton/skeleton.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/feed_search/providers/feed_search_history_provider.dart';
import 'package:ice/app/features/user/providers/user_data_provider.dart';
import 'package:ice/app/utils/username.dart';

class FeedSearchResultsListItem extends ConsumerWidget {
  const FeedSearchResultsListItem({required this.userId, super.key});

  static double get itemVerticalOffset => 8.0.s;

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider(userId));
    return Padding(
      padding: EdgeInsets.symmetric(vertical: itemVerticalOffset),
      child: ScreenSideOffset.small(
        child: userData.maybeWhen(
          data: (userData) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              ref.read(feedSearchHistoryProvider.notifier).addUserIdToTheHistory(userData.pubkey);
            },
            child: ListItem.user(
              title: Text(userData.displayName ?? userData.name ?? userData.pubkey),
              subtitle: Text(
                prefixUsername(username: userData.name ?? userData.pubkey, context: context),
              ),
              profilePicture: userData.picture,
              verifiedBadge: userData.verified,
              ntfAvatar: userData.nft,
            ),
          ),
          orElse: () => const Skeleton(child: ListItemUserShape()),
        ),
      ),
    );
  }
}
