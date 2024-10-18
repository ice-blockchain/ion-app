// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/chat/providers/mock.dart';
import 'package:ice/app/utils/date.dart';
import 'package:ice/generated/assets.gen.dart';

class RecentChatTile extends StatelessWidget {
  const RecentChatTile(this.chat, {super.key});
  final RecentChatDataModel chat;

  @override
  Widget build(BuildContext context) {
    return Row(
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

  String _getMessageContentText(RecentChatMessage message, BuildContext context) {
    switch (message) {
      case final TextRecentChatMessage textMessage:
        return textMessage.text;
      case final ReplayRecentChatMessage replayMessage:
        return replayMessage.text;
      case final DocumentRecentChatMessage documentMessage:
        return documentMessage.fileName;
      case final LinkRecentChatMessage linkMessage:
        return linkMessage.link;
      case final ProfileShareRecentChatMessage profileShareMessage:
        return profileShareMessage.displayName;
      case final MoneyRequestRecentChatMessage _:
        return context.i18n.chat_recents_money_request_message;
      case final PhotoRecentChatMessage _:
        return context.i18n.common_photo;
      case final VoiceRecentChatMessage _:
        return context.i18n.common_voice_message;
      case final VideoRecentChatMessage _:
        return context.i18n.common_video;
      case final PollRecentChatMessage _:
        return context.i18n.common_poll;
    }
  }
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
        child: messageIconPath.icon(size: 16.0.s),
      );
    }
    return const SizedBox.shrink();
  }

  String? _getMessageIcon() {
    switch (message) {
      case final TextRecentChatMessage _:
        return null;
      case final PhotoRecentChatMessage _:
        return Assets.svg.iconProfileCamera;
      case final VoiceRecentChatMessage _:
        // TODO add voice message icon when design is ready
        return Assets.svg.iconProfileCamera;
      case final ReplayRecentChatMessage _:
        // TODO add replay message icon when design is ready
        return Assets.svg.iconProfileCamera;
      case final VideoRecentChatMessage _:
        return Assets.svg.iconFeedVideos;
      case final DocumentRecentChatMessage _:
        return Assets.svg.iconChatFile;
      case final LinkRecentChatMessage _:
        return Assets.svg.iconArticleLink;
      case final ProfileShareRecentChatMessage _:
        return Assets.svg.iconProfileUsertab;
      case final PollRecentChatMessage _:
        return Assets.svg.iconPostPoll;
      case final MoneyRequestRecentChatMessage _:
        return Assets.svg.iconProfileTips;
    }
  }
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
