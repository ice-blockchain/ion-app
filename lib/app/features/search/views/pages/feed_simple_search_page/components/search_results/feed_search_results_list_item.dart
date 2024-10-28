// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/utils/username.dart';

class FeedSearchResultsListItem extends ConsumerWidget {
  const FeedSearchResultsListItem({required this.pubKey, super.key});

  static double get itemVerticalOffset => 8.0.s;

  final String pubKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(userMetadataProvider(pubKey));
    return Padding(
      padding: EdgeInsets.symmetric(vertical: itemVerticalOffset),
      child: ScreenSideOffset.small(
        child: userMetadata.maybeWhen(
          data: (userMetadata) {
            if (userMetadata == null) {
              return const SizedBox.shrink();
            }

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                ref
                    .read(feedSearchHistoryProvider.notifier)
                    .addUserIdToTheHistory(userMetadata.pubkey);
              },
              child: ListItem.user(
                title: Text(userMetadata.displayName),
                subtitle: Text(
                  prefixUsername(username: userMetadata.name, context: context),
                ),
                profilePicture: userMetadata.picture,
                verifiedBadge: userMetadata.verified,
                ntfAvatar: userMetadata.nft,
              ),
            );
          },
          orElse: () => const Skeleton(child: ListItemUserShape()),
        ),
      ),
    );
  }
}
