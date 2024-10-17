// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/components/separated/separator.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/chat/views/pages/chat_list_page/mock.dart';
import 'package:ice/app/utils/date.dart';
import 'package:ice/generated/assets.gen.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mockConversationData = [
      Conversation(
        ConversationSender(
          'Mike Planton',
          'https://i.pravatar.cc/150?u=@john',
          isApproved: true,
          isIceUser: false,
        ),
        1,
        ConversationTextMessage(
          '🪙 In the coming days, we will find out who is behind the creation of Bitcoin!',
          DateTime.now(),
        ),
      ),
      Conversation(
        ConversationSender(
          'Alicia Wernet',
          'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
          isApproved: false,
          isIceUser: true,
        ),
        3,
        ConversationPhotoMessage(
          DateTime.now().subtract(const Duration(minutes: 5)),
        ),
      ),
      Conversation(
        ConversationSender(
          'Ice Open Network',
          'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
          isApproved: true,
          isIceUser: false,
        ),
        3,
        ConversationTextMessage(
          'Hi ☃️ Snowman, 🚨 Join us for an exclusive AMA session on X Spaces...',
          DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ),
      Conversation(
        ConversationSender(
          'Paul Walker',
          'https://i.pravatar.cc/150?u=@paul',
          isApproved: false,
          isIceUser: false,
        ),
        123,
        ConversationVoiceMessage(
          DateTime.now().subtract(const Duration(days: 5)),
        ),
      ),
      Conversation(
        ConversationSender(
          'Danzel York',
          'https://i.pravatar.cc/150?u=@danzel',
          isApproved: true,
          isIceUser: false,
        ),
        3,
        ConversationReplayMessage(
          'Hi, folks 👋',
          DateTime.now().subtract(const Duration(days: 10)),
        ),
      ),
      Conversation(
        ConversationSender(
          'David Glover',
          'https://i.pravatar.cc/150?u=@david',
          isApproved: false,
          isIceUser: false,
        ),
        123,
        ConversationVideoMessage(
          DateTime.now().subtract(const Duration(days: 133)),
        ),
      ),
      Conversation(
        ConversationSender(
          'John Doe',
          'https://i.pravatar.cc/150?u=@john',
          isApproved: true,
          isIceUser: false,
        ),
        3,
        ConversationDocumentMessage(
          'Whitepaper.pdf',
          DateTime.now().subtract(const Duration(days: 400)),
        ),
      ),
      Conversation(
        ConversationSender(
          'Mike Planton',
          'https://i.pravatar.cc/150?u=@mike',
          isApproved: true,
          isIceUser: false,
        ),
        1,
        ConversationLinkMessage(
          'https://ice.network',
          DateTime.now().subtract(const Duration(days: 500)),
        ),
      ),
      Conversation(
        ConversationSender(
          'Alicia Wernet',
          'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
          isApproved: false,
          isIceUser: true,
        ),
        3,
        ConversationProfileShareMessage(
          'Alicia Wernet',
          DateTime.now().subtract(const Duration(days: 600)),
        ),
      ),
      Conversation(
        ConversationSender(
          'Ice Open Network',
          'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
          isApproved: true,
          isIceUser: false,
        ),
        3,
        ConversationPollMessage(
          DateTime.now().subtract(const Duration(days: 700)),
        ),
      ),
      Conversation(
        ConversationSender(
          'Paul Walker',
          'https://i.pravatar.cc/150?u=@paul',
          isApproved: false,
          isIceUser: false,
        ),
        123,
        ConversationMoneyRequestMessage(
          DateTime.now().subtract(const Duration(days: 800)),
        ),
      ),
    ];
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            separatorBuilder: (_, __) => Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8.0.s,
              ),
              child: const HorizontalSeparator(),
            ),
            itemCount: mockConversationData.length,
            itemBuilder: (BuildContext context, int index) {
              //add top seperator if index is 0
              if (index == 0) {
                return Column(
                  children: [
                    const HorizontalSeparator(),
                    ChatListItem(mockConversationData[index]),
                  ],
                );
              }
              if (index == mockConversationData.length - 1) {
                return ChatListItem(mockConversationData[index]);
              }
              final conversation = mockConversationData[index];
              return ChatListItem(conversation);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 12.0.s,
            bottom: 8.0.s,
          ),
          child: const HorizontalSeparator(),
        ),
      ],
    );
  }
}

class ChatListItem extends StatelessWidget {
  const ChatListItem(this.conversation, {super.key});
  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Avatar(
          imageUrl: conversation.sender.imageUrl,
          size: 40.0.s,
        ),
        SizedBox(width: 12.0.s),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        conversation.sender.name,
                        style: context.theme.appTextThemes.subtitle3,
                      ),
                      if (conversation.sender.isIceUser)
                        Padding(
                          padding: EdgeInsets.only(
                            left: 4.0.s,
                          ),
                          child: Assets.svg.iconBadgeIcelogo.icon(
                            size: 16.0.s,
                          ),
                        ),
                      if (conversation.sender.isApproved)
                        Padding(
                          padding: EdgeInsets.only(
                            left: 4.0.s,
                          ),
                          child: Assets.svg.iconBadgeVerify.icon(
                            size: 16.0.s,
                          ),
                        ),
                    ],
                  ),
                  Text(
                    formatMessageTimestamp(conversation.message.time),
                    style: context.theme.appTextThemes.body2.copyWith(
                      color: context.theme.appColors.onTertararyBackground,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.0.s),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        _getMessageIcon(conversation.message),
                        Flexible(
                          child: Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            _getMessageContentText(conversation.message),
                            style: context.theme.appTextThemes.body2.copyWith(
                              color: context.theme.appColors.onTertararyBackground,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (conversation.unreadMessageCount > 0)
                    Container(
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
                      padding: EdgeInsets.fromLTRB(
                        5.0.s,
                        0,
                        5.0.s,
                        1.0.s,
                      ),
                      margin: EdgeInsets.only(
                        left: 8.0.s,
                      ),
                      child: Text(
                        conversation.unreadMessageCount.toString(),
                        textAlign: TextAlign.center,
                        style: context.theme.appTextThemes.caption3.copyWith(
                          height: 1,
                          color: context.theme.appColors.onPrimaryAccent,
                          fontFeatures: [
                            const FontFeature.enable(
                              'liga',
                            ),
                            const FontFeature.disable('clig'),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // use record
  String _getMessageContentText(ConversationMessage message) {
    switch (message) {
      case final ConversationTextMessage textMessage:
        return textMessage.text;
      case final ConversationPhotoMessage _:
        return 'Photo';
      case final ConversationVoiceMessage _:
        return 'Voice message';
      case final ConversationVideoMessage _:
        return 'Video';
      case final ConversationReplayMessage replayMessage:
        return replayMessage.text;
      case final ConversationDocumentMessage documentMessage:
        return documentMessage.fileName;
      case final ConversationLinkMessage linkMessage:
        return linkMessage.link;
      case final ConversationProfileShareMessage profileShareMessage:
        return profileShareMessage.displayName;
      case final ConversationPollMessage _:
        return 'Poll';
      case final ConversationMoneyRequestMessage _:
        return 'Money requested';
    }
  }

  Widget _getMessageIcon(ConversationMessage message) {
    final Widget? messageIcon;
    switch (message) {
      case final ConversationPhotoMessage _:
        messageIcon = Assets.svg.iconProfileCamera.icon(
          size: 16.0.s,
        );
      case final ConversationVoiceMessage _:
        messageIcon = Assets.svg.iconProfileCamera.icon(
          size: 16.0.s,
        );
      case final ConversationReplayMessage _:
        messageIcon = Assets.svg.iconProfileCamera.icon(
          size: 16.0.s,
        );
      case final ConversationVideoMessage _:
        messageIcon = Assets.svg.iconProfileCamera.icon(
          size: 16.0.s,
        );
      case final ConversationDocumentMessage _:
        messageIcon = Assets.svg.iconProfileCamera.icon(
          size: 16.0.s,
        );
      case final ConversationTextMessage _:
        messageIcon = null;
      case final ConversationLinkMessage _:
        messageIcon = Assets.svg.iconProfileCamera.icon(
          size: 16.0.s,
        );
      case final ConversationProfileShareMessage _:
        messageIcon = Assets.svg.iconProfileCamera.icon(
          size: 16.0.s,
        );
      case final ConversationPollMessage _:
        messageIcon = Assets.svg.iconProfileCamera.icon(
          size: 16.0.s,
        );
      case final ConversationMoneyRequestMessage _:
        messageIcon = Assets.svg.iconProfileCamera.icon(
          size: 16.0.s,
        );
    }

    if (messageIcon != null) {
      return Padding(
        padding: EdgeInsets.only(
          right: 2.0.s,
        ),
        child: messageIcon,
      );
    }
    return const SizedBox.shrink();
  }
}
