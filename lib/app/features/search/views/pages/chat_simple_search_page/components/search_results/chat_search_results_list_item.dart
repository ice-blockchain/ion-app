// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/providers/feed_search_history_provider.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/utils/username.dart';
import 'package:ion/generated/assets.gen.dart';

class ChatSearchResultsListItem extends ConsumerWidget {
  const ChatSearchResultsListItem({required this.pubkey, super.key});

  static double get itemVerticalOffset => 8.0.s;

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(userMetadataProvider(pubkey));
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
                    .addUserIdToTheHistory(userMetadata.masterPubkey);
              },
              child: Row(
                children: [
                  Expanded(
                    child: ListItem.user(
                      title: Text(userMetadata.data.displayName),
                      subtitle: Text(
                        prefixUsername(username: userMetadata.data.name, context: context),
                      ),
                      profilePicture: userMetadata.data.picture,
                      verifiedBadge: userMetadata.data.verified,
                      ntfAvatar: userMetadata.data.nft,
                    ),
                  ),
                  Assets.svg.iconArrowRight.icon(
                    size: 24.0.s,
                    color: context.theme.appColors.tertararyText,
                  ),
                ],
              ),
            );
          },
          orElse: () => const Skeleton(child: ListItemUserShape()),
        ),
      ),
    );
  }
}
