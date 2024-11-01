// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/mesage_timestamp.dart';
import 'package:ion/app/features/chat/messages/views/components/message_item_wrapper.dart';
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Avatar(
                        size: 40.0.s,
                        imageUrl:
                            'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
                      ),
                      SizedBox(width: 8.0.s),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'John Doe',
                            style: context.theme.appTextThemes.subtitle3.copyWith(
                              color: isMe
                                  ? context.theme.appColors.onPrimaryAccent
                                  : context.theme.appColors.primaryText,
                            ),
                          ),
                          Text(
                            prefixUsername(context: context, username: 'johndoe'),
                            style: context.theme.appTextThemes.body2.copyWith(
                              color: isMe
                                  ? context.theme.appColors.onPrimaryAccent
                                  : context.theme.appColors.onTertararyBackground,
                            ),
                          ),
                        ],
                      ),
                    ],
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
                        'Write a message',
                        style: context.theme.appTextThemes.caption2.copyWith(
                          color: context.theme.appColors.primaryText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16.0.s),
              MessageTimeStamp(isMe: isMe),
            ],
          ),
        ],
      ),
    );
  }
}
