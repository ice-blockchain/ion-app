// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/providers/feed_search_history_provider.c.dart';
import 'package:ion/app/features/search/views/pages/chat_simple_search_page/components/search_results/chat_search_list_item_shape.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/utils/username.dart';
import 'package:ion/generated/assets.gen.dart';

class ChatSimpleSearchResultListItem extends ConsumerWidget {
  const ChatSimpleSearchResultListItem({required this.pubkeyAndContent, super.key});

  static double get itemVerticalOffset => 8.0.s;

  final MapEntry<String, String> pubkeyAndContent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(userMetadataProvider(pubkeyAndContent.key));

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
                context.pushReplacement(
                  ConversationRoute(receiverPubKey: pubkeyAndContent.key).location,
                );
              },
              child: Row(
                children: [
                  Expanded(
                    child: ListItem.user(
                      profilePicture: userMetadata.data.picture,
                      title: Text(userMetadata.data.displayName),
                      subtitle: pubkeyAndContent.value.isNotEmpty
                          ? Text(
                              pubkeyAndContent.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : Text(
                              prefixUsername(username: userMetadata.data.name, context: context),
                            ),
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
          orElse: () => const Skeleton(child: ChatSimpleSearchListItemShape()),
        ),
      ),
    );
  }
}
