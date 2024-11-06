// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class MessageTimeStamp extends StatelessWidget {
  const MessageTimeStamp({
    required this.isMe,
    super.key,
  });

  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0.s),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '12:23',
            style: context.theme.appTextThemes.caption4.copyWith(
              color: isMe
                  ? context.theme.appColors.strokeElements
                  : context.theme.appColors.quaternaryText,
            ),
          ),
          if (isMe)
            Padding(
              padding: EdgeInsets.only(left: 2.0.s),
              child: Assets.svg.iconMessageReaded.icon(
                color: context.theme.appColors.strokeElements,
                size: 12.0.s,
              ),
            ),
        ],
      ),
    );
  }
}
