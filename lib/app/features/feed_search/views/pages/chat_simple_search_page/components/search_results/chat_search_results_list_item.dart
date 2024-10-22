// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed_search/providers/feed_search_history_provider.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';
import 'package:ion/app/utils/username.dart';
import 'package:ion/generated/assets.gen.dart';

class ChatSearchResultsListItem extends ConsumerWidget {
  const ChatSearchResultsListItem({required this.userId, super.key});

  static double get itemVerticalOffset => 8.0.s;

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(userMetadataProvider(userId));
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
              child: Row(
                children: [
                  Expanded(
                    child: ListItem.user(
                      title: Text(userMetadata.displayName),
                      subtitle: Text(
                        prefixUsername(username: userMetadata.name, context: context),
                      ),
                      profilePicture: userMetadata.picture,
                      verifiedBadge: userMetadata.verified,
                      ntfAvatar: userMetadata.nft,
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
