// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/components/separated/separator.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/chat/views/pages/chat_list_page/mock.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:intl/intl.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 12.0.s,
            bottom: 8.0.s,
          ),
          child: const HorizontalSeparator(),
        ),
        ListView.separated(
          separatorBuilder: (_, __) => Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8.0.s,
            ),
            child: const HorizontalSeparator(),
          ),
          shrinkWrap: true,
          itemCount: mockConversationData.length,
          itemBuilder: (BuildContext context, int index) {
            final conversation = mockConversationData[index];
            return ChatListItem(conversation);
          },
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
                    DateFormat.Hm().format(conversation.message.time),
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
                    child: Text(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      _getMessageContent(conversation.message),
                      style: context.theme.appTextThemes.body2.copyWith(
                        color: context.theme.appColors.onTertararyBackground,
                      ),
                    ),
                  ),
                  SizedBox(width: 14.0.s),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(16.0.s), // Use a large radius for pill shape
                      color: context.theme.appColors.primaryAccent,
                    ),
                    alignment: Alignment.center,
                    constraints: BoxConstraints(
                      minWidth: 16.0.s, // Minimum width to maintain circle for small numbers
                      minHeight: 16.0.s, // Fixed height for pill shape
                      maxHeight: 16.0.s, // Fixed height for pill shape
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.0.s,
                    ),
                    child: Text(
                      conversation.unreadMessageCount.toString(),
                      textAlign: TextAlign.center,
                      style: context.theme.appTextThemes.caption3.copyWith(
                        color: context.theme.appColors.onPrimaryAccent,
                        height: 1,
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

  String _getMessageContent(ConversationMessageAbstract message) {
    //switch on sealed class
    switch (message) {
      case final ConversationTextMessage textMessage:
        return textMessage.text;
      case final ConversationPhotoMessage _:
        return 'Photo';
    }
  }
}
