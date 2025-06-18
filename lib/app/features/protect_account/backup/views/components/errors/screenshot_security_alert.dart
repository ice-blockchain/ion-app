// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class ScreenshotSecurityAlert extends StatelessWidget {
  const ScreenshotSecurityAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 20.0.s),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.s),
          child: InfoCard(
            iconAsset: Assets.svgActionWalletScreenshot,
            title: context.i18n.error_screenshots_arent_secure_title,
            description: context.i18n.error_screenshots_arent_secure_description,
          ),
        ),
        SizedBox(height: 20.0.s),
        ScreenSideOffset.small(
          child: Button(
            label: Text(context.i18n.button_continue),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        ScreenBottomOffset(margin: 36.0.s),
      ],
    );
  }
}
