// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class ChatEmptyView extends StatelessWidget {
  const ChatEmptyView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.svg.walletChatEmptystate.icon(
            size: 48.0.s,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0.s),
            child: Text(
              context.i18n.chat_empty_description,
              style: context.theme.appTextThemes.caption2.copyWith(
                color: context.theme.appColors.onTertararyBackground,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Padding(
              padding: EdgeInsets.all(UiConstants.hitSlop),
              child: Text(
                context.i18n.chat_new_message_button,
                style: context.theme.appTextThemes.caption
                    .copyWith(color: context.theme.appColors.primaryAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
