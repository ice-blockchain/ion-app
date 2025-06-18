// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class NewChatInitialView extends StatelessWidget {
  const NewChatInitialView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScreenSideOffset.small(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const IconAsset(Assets.svgWalletChatNewchat, size: 48),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.s, horizontal: 78.0.s),
              child: Text(
                context.i18n.new_chat_modal_description,
                style: context.theme.appTextThemes.caption2.copyWith(
                  color: context.theme.appColors.onTertararyBackground,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
