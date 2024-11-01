// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/mesage_timestamp.dart';
import 'package:ion/app/features/chat/messages/views/components/message_item_wrapper.dart';
import 'package:ion/generated/assets.gen.dart';

class MoneyRequestMessage extends StatelessWidget {
  const MoneyRequestMessage({required this.isMe, super.key});
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return MessageItemWrapper(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.0.s,
        vertical: 12.0.s,
      ),
      isMe: isMe,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Money requested',
            style: context.theme.appTextThemes.body2.copyWith(
              color: isMe
                  ? context.theme.appColors.onPrimaryAccent
                  : context.theme.appColors.primaryText,
            ),
          ),
          SizedBox(height: 10.0.s),
          Row(
            children: [
              Assets.svg.walletIce.icon(
                size: 36.0.s,
              ),
              SizedBox(width: 8.0.s),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '10,000.00 ICE',
                        style: context.theme.appTextThemes.subtitle3.copyWith(
                          color: isMe
                              ? context.theme.appColors.onPrimaryAccent
                              : context.theme.appColors.primaryText,
                        ),
                      ),
                      SizedBox(width: 4.0.s),
                      Text(
                        '~ 59.99 USD',
                        style: context.theme.appTextThemes.body2.copyWith(
                          color: isMe
                              ? context.theme.appColors.strokeElements
                              : context.theme.appColors.quaternaryText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0.s),
                  Container(
                    decoration: BoxDecoration(
                      color: isMe
                          ? context.theme.appColors.tertararyBackground
                          : context.theme.appColors.onSecondaryBackground,
                      borderRadius: BorderRadius.circular(4.0.s),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.0.s,
                    ),
                    child: Text(
                      'BNB Smart Chain',
                      style: context.theme.appTextThemes.caption3.copyWith(
                        color: isMe
                            ? context.theme.appColors.quaternaryText
                            : context.theme.appColors.quaternaryText,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.0.s),
          Button.compact(
            type: isMe ? ButtonType.secondary : ButtonType.primary,
            tintColor: isMe ? context.theme.appColors.darkBlue : null,
            minimumSize: Size(150.0.s, 32.0.s),
            label: Text(
              'Send',
              style: context.theme.appTextThemes.caption2.copyWith(
                color: isMe
                    ? context.theme.appColors.primaryText
                    : context.theme.appColors.onPrimaryAccent,
              ),
            ),
            onPressed: () {},
          ),
          Align(
            alignment: Alignment.centerRight,
            child: MessageTimeStamp(isMe: isMe),
          ),
        ],
      ),
    );
  }
}
