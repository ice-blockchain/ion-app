// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat-v2/recent_chats/model/conversation_list_item.c.dart';
import 'package:ion/app/features/chat-v2/recent_chats/providers/conversations_edit_mode_provider.c.dart';
import 'package:ion/app/features/chat-v2/recent_chats/providers/selected_conversations_ids_provider.c.dart';
import 'package:ion/app/features/chat-v2/recent_chats/views/components/recent_chat_seperator/recent_chat_seperator.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/generated/assets.gen.dart';

class RecentChatTile extends HookConsumerWidget {
  const RecentChatTile({
    required this.conversation,
    required this.name,
    required this.defaultAvatar,
    required this.lastMessageAt,
    required this.lastMessageContent,
    required this.unreadMessagesCount,
    required this.onTap,
    this.avatarUrl,
    this.avatarWidget,
    super.key,
  });

  final ConversationListItem conversation;
  final String name;
  final String? avatarUrl;
  final Widget? defaultAvatar;
  final DateTime lastMessageAt;
  final String lastMessageContent;
  final int unreadMessagesCount;
  final VoidCallback? onTap;
  final Widget? avatarWidget;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = ref.watch(conversationsEditModeProvider);
    final selectedConversations = ref.watch(selectedConversationsProvider);

    return GestureDetector(
      onTap: () {
        if (isEditMode) {
          ref.read(selectedConversationsProvider.notifier).toggle(conversation);
        } else {
          onTap?.call();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isEditMode ? 40.0.s : 0,
                child: Padding(
                  padding: EdgeInsets.only(right: 10.0.s),
                  child: selectedConversations.contains(conversation)
                      ? Assets.svg.iconBlockCheckboxOn.icon(size: 24.0.s)
                      : Assets.svg.iconBlockCheckboxOff.icon(size: 24.0.s),
                ),
              ),
              Flexible(
                child: Row(
                  children: [
                    Avatar(
                      imageUrl: avatarUrl,
                      imageWidget: avatarWidget,
                      defaultAvatar: defaultAvatar,
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
          const RecentChatSeparator(),
        ],
      ),
    );
  }
}

class SenderSummary extends ConsumerWidget {
  const SenderSummary({required this.pubkey, this.textColor, super.key});

  final String pubkey;

  final Color? textColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userMetadataProvider(pubkey)).valueOrNull?.data;

    if (user == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Text(
          user.name,
          style: context.theme.appTextThemes.subtitle3.copyWith(
            color: textColor ?? context.theme.appColors.primaryText,
          ),
        ),
        // if (sender.isIceUser)
        //   Padding(
        //     padding: EdgeInsets.only(left: 4.0.s),
        //     child: Assets.svg.iconBadgeIcelogo.icon(size: 16.0.s),
        //   ),
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

// class RecentChatMessageIcon extends StatelessWidget {
//   const RecentChatMessageIcon({required this.message, this.color, super.key});

//   final RecentChatMessage message;
//   final Color? color;

//   @override
//   Widget build(BuildContext context) {
//     final messageIconPath = _getMessageIcon();

//     if (messageIconPath != null) {
//       return Padding(
//         padding: EdgeInsets.only(right: 2.0.s),
//         child: messageIconPath.icon(
//           size: 16.0.s,
//           color: color ?? context.theme.appColors.onTertararyBackground,
//         ),
//       );
//     }
//     return const SizedBox.shrink();
//   }

//   String? _getMessageIcon() => switch (message) {
//         TextRecentChatMessage _ => null,
//         SystemRecentChatMessage _ => null,
//         VideoRecentChatMessage _ => Assets.svg.iconFeedVideos,
//         DocumentRecentChatMessage _ => Assets.svg.iconChatFile,
//         LinkRecentChatMessage _ => Assets.svg.iconArticleLink,
//         ProfileShareRecentChatMessage _ => Assets.svg.iconProfileUsertab,
//         PollRecentChatMessage _ => Assets.svg.iconPostPoll,
//         MoneyRequestRecentChatMessage _ => Assets.svg.iconProfileTips,
//         PhotoRecentChatMessage _ => Assets.svg.iconLoginCamera,
//         VoiceRecentChatMessage _ => Assets.svg.iconChatVoicemessage,
//         ReplayRecentChatMessage _ => Assets.svg.iconChatReplymessage,
//       };
// }

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
