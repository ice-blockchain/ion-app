// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/components/avatar/default_avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/message_author.c.dart';
import 'package:ion/app/features/chat/providers/mock.dart';
import 'package:ion/app/features/chat/recent_chats/providers/conversations_edit_mode_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/selected_conversations_ids_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/generated/assets.gen.dart';

class RecentChatTile extends HookConsumerWidget {
  const RecentChatTile({
    required this.uuid,
    required this.name,
    required this.avatarUrl,
    required this.defaultAvatar,
    required this.lastMessageAt,
    required this.lastMessageContent,
    required this.unreadMessagesCount,
    super.key,
  });

  final String uuid;
  final String name;
  final String? avatarUrl;
  final String? defaultAvatar;
  final DateTime lastMessageAt;
  final String lastMessageContent;
  final int unreadMessagesCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = ref.watch(conversationsEditModeProvider);
    final selectedConversationsIds = ref.watch(selectedConversationsIdsProvider);
    final conversationWithMetadata =
        ref.watch(conversationMetadataProvider(conversation)).value ?? conversation;

    ref.displayErrors(conversationMetadataProvider(conversation));

    return GestureDetector(
      onTap: () {
        if (isEditMode) {
          ref.read(selectedConversationsIdsProvider.notifier).toggle(uuid);
        } else {
          ChannelRoute(uuid: uuid).push<void>(context);
          // MessagesRoute(
          //   id: conversationData.id,
          //   name: conversationData.name,
          //   chatType: conversationData.type,
          //   imageUrl: conversationData.imageUrl,
          //   participants: conversationData.participants,
          //   nickname: prefixUsername(username: conversationData.nickname, context: context),
          // ).push<void>(context);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isEditMode ? 40.0.s : 0,
            child: Padding(
              padding: EdgeInsets.only(right: 10.0.s),
              child: selectedConversationsIds.contains(uuid)
                  ? Assets.svg.iconBlockCheckboxOn.icon(size: 24.0.s)
                  : Assets.svg.iconBlockCheckboxOff.icon(size: 24.0.s),
            ),
          ),
          Flexible(
            child: Row(
              children: [
                Avatar(
                  imageUrl: avatarUrl,
                  size: 40.0.s,
                ),
                SizedBox(width: 12.0.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            name,
                            style: context.theme.appTextThemes.subtitle3.copyWith(
                              color: context.theme.appColors.primaryText,
                            ),
                          ),
                          ChatTimestamp(lastMessageAt),
                        ],
                      ),
                      SizedBox(height: 2.0.s),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ChatPreview(content: lastMessageContent),
                          ),
                          UnreadCountBadge(unreadCount: unreadMessagesCount),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SenderSummary extends StatelessWidget {
  const SenderSummary({required this.sender, this.textColor, super.key});

  final MessageAuthor sender;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          sender.name,
          style: context.theme.appTextThemes.subtitle3.copyWith(
            color: textColor ?? context.theme.appColors.primaryText,
          ),
        ),
        if (sender.isIceUser)
          Padding(
            padding: EdgeInsets.only(left: 4.0.s),
            child: Assets.svg.iconBadgeIcelogo.icon(size: 16.0.s),
          ),
      ],
    );
  }
}

class ChatTimestamp extends StatelessWidget {
  const ChatTimestamp(this.time, {super.key});

  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return Text(
      formatMessageTimestamp(time),
      style: context.theme.appTextThemes.body2.copyWith(
        color: context.theme.appColors.onTertararyBackground,
      ),
    );
  }
}

class ChatPreview extends StatelessWidget {
  const ChatPreview({
    required this.content,
    this.textColor,
    this.maxLines = 2,
    super.key,
  });

  final String content;
  final Color? textColor;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //RecentChatMessageIcon(message: message, color: textColor),
        Flexible(
          child: Text(
            content.isNotEmpty ? content : context.i18n.group_create_first_message,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: context.theme.appTextThemes.body2.copyWith(
              fontStyle: content.isEmpty ? FontStyle.italic : FontStyle.normal,
              color: textColor ?? context.theme.appColors.onTertararyBackground,
            ),
          ),
        ),
      ],
    );
  }
}

class RecentChatMessageIcon extends StatelessWidget {
  const RecentChatMessageIcon({required this.message, this.color, super.key});

  final RecentChatMessage message;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final messageIconPath = _getMessageIcon();

    if (messageIconPath != null) {
      return Padding(
        padding: EdgeInsets.only(right: 2.0.s),
        child: messageIconPath.icon(
          size: 16.0.s,
          color: color ?? context.theme.appColors.onTertararyBackground,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  String? _getMessageIcon() => switch (message) {
        TextRecentChatMessage _ => null,
        SystemRecentChatMessage _ => null,
        VideoRecentChatMessage _ => Assets.svg.iconFeedVideos,
        DocumentRecentChatMessage _ => Assets.svg.iconChatFile,
        LinkRecentChatMessage _ => Assets.svg.iconArticleLink,
        ProfileShareRecentChatMessage _ => Assets.svg.iconProfileUsertab,
        PollRecentChatMessage _ => Assets.svg.iconPostPoll,
        MoneyRequestRecentChatMessage _ => Assets.svg.iconProfileTips,
        PhotoRecentChatMessage _ => Assets.svg.iconLoginCamera,
        VoiceRecentChatMessage _ => Assets.svg.iconChatVoicemessage,
        ReplayRecentChatMessage _ => Assets.svg.iconChatReplymessage,
      };
}

class UnreadCountBadge extends StatelessWidget {
  const UnreadCountBadge({required this.unreadCount, super.key});

  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    if (unreadCount == 0) {
      return SizedBox(width: 24.0.s);
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0.s),
        color: context.theme.appColors.primaryAccent,
      ),
      alignment: Alignment.center,
      constraints: BoxConstraints(
        minWidth: 16.0.s,
        minHeight: 16.0.s,
        maxHeight: 16.0.s,
      ),
      padding: EdgeInsets.fromLTRB(5.0.s, 0, 5.0.s, 1.0.s),
      margin: EdgeInsets.only(left: 16.0.s),
      child: Text(
        unreadCount.toString(),
        textAlign: TextAlign.center,
        style: context.theme.appTextThemes.caption3.copyWith(
          height: 1,
          color: context.theme.appColors.onPrimaryAccent,
          fontFeatures: [
            const FontFeature.enable('liga'),
            const FontFeature.disable('clig'),
          ],
        ),
      ),
    );
  }
}
