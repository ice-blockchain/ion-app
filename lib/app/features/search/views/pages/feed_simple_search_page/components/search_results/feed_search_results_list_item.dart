// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/providers/feed_search_history_provider.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';
import 'package:ion/app/utils/username.dart';

class FeedSearchResultsListItem extends ConsumerWidget {
  const FeedSearchResultsListItem({required this.pubkey, super.key});

  static double get itemVerticalOffset => 8.0.s;

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(userMetadataProvider(pubkey));
    return Padding(
      padding: EdgeInsets.symmetric(vertical: itemVerticalOffset),
      child: ScreenSideOffset.small(
        child: userMetadata.maybeWhen(
          data: (userMetadataEntity) {
            if (userMetadataEntity == null) {
              return const SizedBox.shrink();
            }

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                ref
                    .read(feedSearchHistoryProvider.notifier)
                    .addUserIdToTheHistory(userMetadataEntity.pubkey);
              },
              child: ListItem.user(
                title: Text(userMetadataEntity.data.displayName),
                subtitle: Text(
                  prefixUsername(username: userMetadataEntity.data.name, context: context),
                ),
                profilePicture: userMetadataEntity.data.picture,
                verifiedBadge: userMetadataEntity.data.verified,
                ntfAvatar: userMetadataEntity.data.nft,
              ),
            );
          },
          orElse: () => const Skeleton(child: ListItemUserShape()),
        ),
      ),
    );
  }
}
