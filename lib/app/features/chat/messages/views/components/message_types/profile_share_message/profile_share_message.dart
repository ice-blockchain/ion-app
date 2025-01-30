// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/components.dart';
import 'package:ion/app/features/chat/messages/views/components/message_author/message_author.dart';
import 'package:ion/app/features/chat/messages/views/components/message_reactions/message_reactions.dart';
import 'package:ion/app/features/chat/model/message_author.c.dart';
import 'package:ion/app/features/chat/model/message_reaction_group.c.dart';
import 'package:ion/app/utils/username.dart';

class ProfileShareMessage extends StatelessWidget {
  const ProfileShareMessage({
    required this.isMe,
    required this.createdAt,
    this.isLastMessageFromAuthor = true,
    this.reactions,
    this.author,
    super.key,
  });

  final bool isMe;
  final DateTime createdAt;
  final MessageAuthor? author;
  final bool isLastMessageFromAuthor;
  final List<MessageReactionGroup>? reactions;

  @override
  Widget build(BuildContext context) {
    return MessageItemWrapper(
      isLastMessageFromAuthor: isLastMessageFromAuthor,
      contentPadding: EdgeInsets.all(12.0.s),
      isMe: isMe,
      child: IntrinsicWidth(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MessageAuthorNameWidget(author: author),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProfileSummary(isMe: isMe),
                      SizedBox(height: 8.0.s),
                      Button.compact(
                        type: ButtonType.outlined,
                        backgroundColor: context.theme.appColors.tertararyBackground,
                        onPressed: () {},
                        minimumSize: Size(120.0.s, 32.0.s),
                        label: Padding(
                          padding: EdgeInsets.only(bottom: 2.0.s),
                          child: Text(
                            context.i18n.chat_profile_share_button,
                            style: context.theme.appTextThemes.caption2.copyWith(
                              color: context.theme.appColors.primaryText,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  MessageReactions(reactions: reactions),
                ],
              ),
            ),
            SizedBox(width: 16.0.s),
            MessageMetaData(isMe: isMe, createdAt: createdAt),
          ],
        ),
      ),
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  const _ProfileSummary({
    required this.isMe,
  });

  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: ListItem.user(
        title: Text(
          'Alina Proxima',
          style: context.theme.appTextThemes.subtitle3.copyWith(
            color: isMe
                ? context.theme.appColors.onPrimaryAccent
                : context.theme.appColors.primaryText,
          ),
        ),
        subtitle: Text(
          prefixUsername(username: 'alinaproxima', context: context),
          style: context.theme.appTextThemes.body2.copyWith(
            color: isMe
                ? context.theme.appColors.onPrimaryAccent
                : context.theme.appColors.onTertararyBackground,
          ),
        ),
        profilePicture: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
        avatarSize: 40.0.s,
      ),
    );
  }
}
