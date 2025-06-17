// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class ForwardedMessageInfo extends StatelessWidget {
  const ForwardedMessageInfo({required this.isMe, required this.isPublic, super.key});

  final bool isMe;
  final bool isPublic;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        margin: EdgeInsetsDirectional.only(bottom: 12.0.s),
        decoration: BoxDecoration(
          color: isMe
              ? context.theme.appColors.primaryAccent
              : context.theme.appColors.onPrimaryAccent,
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconAssetColored(
                  Assets.svgIconChatForward,
                  size: 16.0,
                  color: isMe
                      ? context.theme.appColors.strokeElements
                      : context.theme.appColors.onTertararyBackground,
                ),
                SizedBox(width: 4.0.s),
                Text(
                  isPublic ? context.i18n.common_forwarded_from : context.i18n.common_forwarded,
                  style: context.theme.appTextThemes.body2.copyWith(
                    color: isMe
                        ? context.theme.appColors.strokeElements
                        : context.theme.appColors.onTertararyBackground,
                  ),
                ),
              ],
            ),
            if (isPublic)
              Padding(
                padding: EdgeInsetsDirectional.only(top: 4.0.s),
                child: Row(
                  children: [
                    Avatar(size: 20.0.s, imageUrl: 'https://picsum.photos/200/300'),
                    SizedBox(width: 8.0.s),
                    Text(
                      'John Doe',
                      style: context.theme.appTextThemes.body2.copyWith(
                        color: isMe
                            ? context.theme.appColors.onPrimaryAccent
                            : context.theme.appColors.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
