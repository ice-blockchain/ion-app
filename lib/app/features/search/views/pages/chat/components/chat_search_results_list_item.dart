// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/providers/feed_search_history_provider.c.dart';
import 'package:ion/app/features/search/views/pages/chat/components/chat_search_list_item_shape.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/utils/username.dart';
import 'package:ion/generated/assets.gen.dart';

class ChatSearchResultListItem extends ConsumerWidget {
  const ChatSearchResultListItem({
    required this.pubkeyAndContent,
    required this.showLastMessage,
    super.key,
  });

  final bool showLastMessage;
  final MapEntry<String, String> pubkeyAndContent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(userMetadataProvider(pubkeyAndContent.key));

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.s),
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
                      subtitle: pubkeyAndContent.value.isNotEmpty && showLastMessage
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
          orElse: () => const Skeleton(child: ChatSearchListItemShape()),
        ),
      ),
    );
  }
}
