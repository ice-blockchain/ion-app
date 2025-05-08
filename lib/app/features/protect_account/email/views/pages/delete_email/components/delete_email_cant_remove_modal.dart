// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class DeleteEmailCantRemoveModal extends StatelessWidget {
  const DeleteEmailCantRemoveModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 30.0.s),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.0.s),
          child: Column(
            children: [
              InfoCard(
                iconAsset: Assets.svg.actionWalletKeyserror,
                title: context.i18n.two_fa_delete_email_button,
                description: context.i18n.two_fa_delete_email_cant_remove_description,
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0.s),
        ScreenBottomOffset(
          child: ScreenSideOffset.small(
            child: Button(
              onPressed: () => rootNavigatorKey.currentState?.pop(),
              label: Text(context.i18n.button_close),
              mainAxisSize: MainAxisSize.max,
            ),
          ),
        ),
      ],
    );
  }
}
