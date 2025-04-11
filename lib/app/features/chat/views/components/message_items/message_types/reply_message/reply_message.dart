// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_tile/recent_chat_tile.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/visual_media_message/visual_media_custom_grid.dart';
import 'package:ion/generated/assets.gen.dart';

class ReplyMessage extends HookConsumerWidget {
  const ReplyMessage(this.messageItem, this.repliedMessageItem, {super.key});

  final ChatMessageInfoItem messageItem;
  final ChatMessageInfoItem? repliedMessageItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (repliedMessageItem == null) {
      return const SizedBox.shrink();
    }

    final messageIconPath = _getMessageIcon();
    final isMyMessage =
        messageItem.eventMessage.masterPubkey == ref.watch(currentPubkeySelectorProvider);

    final bgColor = useMemoized(
      () => isMyMessage
          ? context.theme.appColors.darkBlue
          : context.theme.appColors.primaryBackground,
      [isMyMessage],
    );

    final textColor = useMemoized(
      () => isMyMessage ? context.theme.appColors.onPrimaryAccent : null,
      [isMyMessage],
    );

    final mediaItem = repliedMessageItem != null && repliedMessageItem is MediaItem
        ? (repliedMessageItem! as MediaItem)
        : null;

    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 12.0.s),
      padding: EdgeInsetsDirectional.fromSTEB(12.0.s, 5.0.s, 20.0.s, 5.0.s),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10.0.s),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SideVerticalDivider(isMyMessage: isMyMessage),
          if (mediaItem != null)
            SizedBox(
              width: 50.0.s,
              child: Padding(
                padding: EdgeInsetsDirectional.only(start: 4.0.s, end: 8.0.s),
                child: VisualMediaCustomGrid(
                  customSpacing: 2.0.s,
                  messageMedias: mediaItem.medias,
                  customHeight: mediaItem.medias.length > 1 ? 16.0.s : 30.0.s,
                  eventMessage: repliedMessageItem!.eventMessage,
                  isReply: true,
                ),
              ),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SenderSummary(
                  textColor: textColor,
                  pubkey: repliedMessageItem!.eventMessage.masterPubkey,
                ),
                Row(
                  children: [
                    if (messageIconPath != null)
                      Padding(
                        padding: EdgeInsetsDirectional.only(end: 4.0.s),
                        child: messageIconPath.icon(
                          size: 16.0.s,
                          color: textColor ?? context.theme.appColors.onTertararyBackground,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        repliedMessageItem!.contentDescription,
                        style: context.theme.appTextThemes.body2.copyWith(color: textColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _getMessageIcon() => switch (repliedMessageItem!) {
        TextItem _ => null,
        EmojiItem _ => null,
        MoneyItem _ => null,
        LinkItem _ => Assets.svg.iconArticleLink,
        DocumentItem _ => Assets.svg.iconChatFile,
        MediaItem _ => Assets.svg.iconProfileCamera,
        AudioItem _ => Assets.svg.iconChatVoicemessage,
        ShareProfileItem _ => Assets.svg.iconProfileUsertab,
      };
}

class _SideVerticalDivider extends StatelessWidget {
  const _SideVerticalDivider({
    required this.isMyMessage,
  });

  final bool isMyMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2.0.s,
      height: 36.0.s,
      margin: EdgeInsetsDirectional.only(end: 6.0.s),
      decoration: BoxDecoration(
        color: isMyMessage
            ? context.theme.appColors.onPrimaryAccent
            : context.theme.appColors.primaryAccent,
        borderRadius: BorderRadius.circular(2.0.s),
      ),
    );
  }
}
