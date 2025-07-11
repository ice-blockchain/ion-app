// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/badges_user_list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/model/chat_search_result_item.f.dart';
import 'package:ion/app/features/search/providers/chat_search/chat_search_history_provider.m.dart';
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
    final userMetadata = item.userMetadata;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        ref
            .read(chatSearchHistoryProvider.notifier)
            .addUserIdToTheHistory(userMetadata.masterPubkey);
        context.pushReplacement(
          ConversationRoute(receiverMasterPubkey: item.userMetadata.masterPubkey).location,
        );
      },
      child: BadgesUserListItem(
        contentPadding:
            EdgeInsets.symmetric(vertical: 8.0.s, horizontal: ScreenSideOffset.defaultSmallMargin),
        pubkey: userMetadata.masterPubkey,
        title: Padding(
          padding: EdgeInsetsDirectional.only(bottom: 2.38.s),
          child: Text(
            userMetadata.data.displayName,
            style: context.theme.appTextThemes.subtitle3.copyWith(
              color: context.theme.appColors.primaryText,
            ),
          ),
        ),
        constraints: BoxConstraints(minHeight: 48.0.s),
        subtitle: item.lastMessageContent.isNotEmpty && showLastMessage
            ? Text(
                item.lastMessageContent!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.theme.appTextThemes.body2.copyWith(
                  color: context.theme.appColors.onTertararyBackground,
                ),
              )
            : Text(
                prefixUsername(username: userMetadata.data.name, context: context),
                style: context.theme.appTextThemes.body2.copyWith(
                  color: context.theme.appColors.onTertararyBackground,
                ),
              ),
        avatarSize: 48.0.s,
        leadingPadding: EdgeInsetsDirectional.only(end: 12.0.s),
        trailing: Assets.svg.iconArrowRight.icon(
          size: 24.0.s,
          color: context.theme.appColors.tertararyText,
        ),
      ),
    );
  }
}
