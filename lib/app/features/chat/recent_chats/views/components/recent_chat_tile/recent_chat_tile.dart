// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/mock.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/generated/assets.gen.dart';

class RecentChatTile extends ConsumerWidget {
  const RecentChatTile(this.chat, {super.key});
  final RecentChatDataModel chat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = ref.watch(conversationsEditModeProvider);

    final selectedConversationsIds = ref.watch(selectedConversationsIdsProvider);

    return GestureDetector(
      onTap: () {
        if (isEditMode) {
          ref.read(selectedConversationsIdsProvider.notifier).toggle(chat.id);
        } else {}
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isEditMode ? 40.0.s : 0,
            child: Padding(
              padding: EdgeInsets.only(right: 10.0.s),
              child: selectedConversationsIds.contains(chat.id)
                  ? Assets.svg.iconBlockCheckboxOn.icon(size: 24.0.s)
                  : Assets.svg.iconBlockCheckboxOff.icon(size: 24.0.s),
            ),
          ),
          Flexible(
            child: Row(
              children: [
                Avatar(
                  imageUrl: chat.sender.imageUrl,
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
                          SenderSummary(chat: chat),
                          ChatTimestamp(chat: chat),
                        ],
                      ),
                      SizedBox(height: 2.0.s),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ChatPreview(chat: chat),
                          UnreadCountBadge(unreadCount: chat.unreadMessageCount),
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
  const SenderSummary({required this.chat, super.key});
  final RecentChatDataModel chat;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          chat.sender.name,
          style: context.theme.appTextThemes.subtitle3,
        ),
        if (chat.sender.isIceUser)
          Padding(
            padding: EdgeInsets.only(left: 4.0.s),
            child: Assets.svg.iconBadgeIcelogo.icon(size: 16.0.s),
          ),
        if (chat.sender.isApproved)
          Padding(
            padding: EdgeInsets.only(left: 4.0.s),
            child: Assets.svg.iconBadgeVerify.icon(size: 16.0.s),
          ),
      ],
    );
  }
}

class ChatTimestamp extends StatelessWidget {
  const ChatTimestamp({
    required this.chat,
    super.key,
  });

  final RecentChatDataModel chat;

  @override
  Widget build(BuildContext context) {
    return Text(
      formatMessageTimestamp(chat.message.time),
      style: context.theme.appTextThemes.body2.copyWith(
        color: context.theme.appColors.onTertararyBackground,
      ),
    );
  }
}

class ChatPreview extends StatelessWidget {
  const ChatPreview({required this.chat, super.key});
  final RecentChatDataModel chat;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          RecentChatMessageIcon(message: chat.message),
          Expanded(
            child: Text(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              _getMessageContentText(chat.message, context),
              style: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.onTertararyBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMessageContentText(RecentChatMessage message, BuildContext context) =>
      switch (message) {
        final TextRecentChatMessage textMessage => textMessage.text,
        final ReplayRecentChatMessage replayMessage => replayMessage.text,
        final DocumentRecentChatMessage documentMessage => documentMessage.fileName,
        final LinkRecentChatMessage linkMessage => linkMessage.link,
        final ProfileShareRecentChatMessage profileShareMessage => profileShareMessage.displayName,
        MoneyRequestRecentChatMessage _ => context.i18n.chat_recents_money_request_message,
        PhotoRecentChatMessage _ => context.i18n.common_photo,
        VoiceRecentChatMessage _ => context.i18n.common_voice_message,
        VideoRecentChatMessage _ => context.i18n.common_video,
        PollRecentChatMessage _ => context.i18n.common_poll,
      };
}

class RecentChatMessageIcon extends StatelessWidget {
  const RecentChatMessageIcon({required this.message, super.key});
  final RecentChatMessage message;

  @override
  Widget build(BuildContext context) {
    final messageIconPath = _getMessageIcon();

    if (messageIconPath != null) {
      return Padding(
        padding: EdgeInsets.only(right: 2.0.s),
        child: messageIconPath.icon(
          size: 16.0.s,
          color: context.theme.appColors.onTertararyBackground,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  String? _getMessageIcon() => switch (message) {
        TextRecentChatMessage _ => null,
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
