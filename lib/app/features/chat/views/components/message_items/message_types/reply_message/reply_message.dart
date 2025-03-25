// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';

import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_tile/recent_chat_tile.dart';
import 'package:ion/app/features/chat/views/components/message_items/replied_message_info/media_preview.dart';
import 'package:ion/generated/assets.gen.dart';

class ReplyMessage extends HookConsumerWidget {
  const ReplyMessage(this.messageItem, this.repliedMessageItem, {super.key});

  final ChatMessageInfoItem messageItem;
  final ChatMessageInfoItem repliedMessageItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return Container(
      margin: EdgeInsets.only(bottom: 12.0.s),
      padding: EdgeInsets.fromLTRB(12.0.s, 5.0.s, 20.0.s, 5.0.s),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10.0.s),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SideVerticalDivider(isMe: isMyMessage),
            repliedMessageItem.maybeWhen(
              photo: (media, eventMessage, contentDescription) => Padding(
                padding: EdgeInsets.only(left: 6.0.s, right: 12.0.s),
                child: MediaPreview(media: media),
              ),
              video: (media, eventMessage, contentDescription) => Padding(
                padding: EdgeInsets.only(left: 6.0.s, right: 12.0.s),
                child: MediaPreview(media: media),
              ),
              orElse: SizedBox.shrink,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SenderSummary(
                    textColor: textColor,
                    pubkey: repliedMessageItem.eventMessage.masterPubkey,
                  ),
                  Row(
                    children: [
                      if (messageIconPath != null)
                        Padding(
                          padding: EdgeInsets.only(right: 4.0.s),
                          child: messageIconPath.icon(
                            size: 16.0.s,
                            color: textColor ?? context.theme.appColors.onTertararyBackground,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          repliedMessageItem.contentDescription,
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
      ),
    );
  }

  String? _getMessageIcon() => switch (repliedMessageItem) {
        TextItem _ => null,
        EmojiItem _ => null,
        VideoItem _ => Assets.svg.iconFeedVideos,
        LinkItem _ => Assets.svg.iconArticleLink,
        DocumentItem _ => Assets.svg.iconChatFile,
        PhotoItem _ => Assets.svg.iconProfileCamera,
        AudioItem _ => Assets.svg.iconChatVoicemessage,
        ShareProfileItem _ => Assets.svg.iconProfileUsertab,
      };
}

class _SideVerticalDivider extends StatelessWidget {
  const _SideVerticalDivider({
    required this.isMe,
  });

  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2.0.s,
      margin: EdgeInsets.only(right: 6.0.s),
      decoration: BoxDecoration(
        color:
            isMe ? context.theme.appColors.onPrimaryAccent : context.theme.appColors.primaryAccent,
        borderRadius: BorderRadius.circular(2.0.s),
      ),
    );
  }
}
