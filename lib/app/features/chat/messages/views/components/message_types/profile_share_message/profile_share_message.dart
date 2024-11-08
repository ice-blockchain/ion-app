// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/messages/views/components/message_metadata/message_metadata.dart';
import 'package:ion/app/utils/username.dart';

class ProfileShareMessage extends StatelessWidget {
  const ProfileShareMessage({required this.isMe, super.key});
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return MessageItemWrapper(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.0.s,
        vertical: 12.0.s,
      ),
      isMe: isMe,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicWidth(
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
                    prefixUsername(context: context, username: 'johndoe'),
                    style: context.theme.appTextThemes.body2.copyWith(
                      color: isMe
                          ? context.theme.appColors.onPrimaryAccent
                          : context.theme.appColors.onTertararyBackground,
                    ),
                  ),
                  profilePicture:
                      'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
                  verifiedBadge: true,
                  avatarSize: 40.0.s,
                ),
              ),
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
          SizedBox(width: 16.0.s),
          MessageMetaData(isMe: isMe),
        ],
      ),
    );
  }
}
