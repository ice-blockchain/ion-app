// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class IdentityNotFoundPopup extends StatelessWidget {
  const IdentityNotFoundPopup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final minSize = Size(56.0.s, 56.0.s);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(start: 30.0.s, end: 30.0.s, top: 30.0.s),
          child: InfoCard(
            iconAsset: Assets.svg.actionWalletKeyserror,
            title: context.i18n.identity_not_found_title,
            description: context.i18n.identity_not_found_desc,
          ),
        ),
        SizedBox(height: 24.0.s),
        ScreenSideOffset.small(
          child: Button(
            label: Text(context.i18n.button_try_again),
            mainAxisSize: MainAxisSize.max,
            minimumSize: minSize,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        ScreenBottomOffset(),
      ],
    );
  }
}
