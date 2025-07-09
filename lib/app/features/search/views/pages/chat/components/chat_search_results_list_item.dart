// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/badges_user_list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/model/chat_search_result_item.f.dart';
import 'package:ion/app/features/search/providers/chat_search_history_provider.m.dart';
import 'package:ion/app/features/search/views/pages/chat/components/chat_search_list_item_shape.dart';
import 'package:ion/app/features/user/model/user_metadata.f.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.r.dart';
import 'package:ion/app/router/app_routes.gr.dart';
import 'package:ion/app/utils/username.dart';
import 'package:ion/generated/assets.gen.dart';

class ChatSearchResultListItem extends ConsumerWidget {
  const ChatSearchResultListItem({
    required this.showLastMessage,
    required this.item,
    super.key,
  });

  final bool showLastMessage;
  final ChatSearchResultItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserMetadataEntity? userMetadata;
    if (item.isFromLocalDb) {
      userMetadata = ref.watch(userMetadataFromDbProvider(item.masterPubkey));
    } else {
      userMetadata = ref.watch(cachedUserMetadataProvider(item.masterPubkey));
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.s),
      child: ScreenSideOffset.small(
        child: userMetadata == null
            ? const Skeleton(child: ChatSearchListItemShape())
            : GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  ref
                      .read(chatSearchHistoryProvider.notifier)
                      .addUserIdToTheHistory(userMetadata!.masterPubkey);
                  context.pushReplacement(
                    ConversationRoute(receiverMasterPubkey: item.masterPubkey).location,
                  );
                },
                child: Row(
                  children: [
                    Expanded(
                      child: BadgesUserListItem(
                        pubkey: userMetadata.masterPubkey,
                        title: Text(userMetadata.data.displayName),
                        subtitle: item.lastMessageContent.isNotEmpty && showLastMessage
                            ? Text(
                                item.lastMessageContent,
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
              ),
      ),
    );
  }
}
