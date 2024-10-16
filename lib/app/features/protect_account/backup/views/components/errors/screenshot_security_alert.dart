// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/modal_sheets/simple_modal_sheet.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class ScreenshotSecurityAlert extends StatelessWidget {
  const ScreenshotSecurityAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleModalSheet.alert(
      title: context.i18n.error_screenshots_arent_secure_title,
      description: context.i18n.error_screenshots_arent_secure_description,
      iconAsset: Assets.svg.actionWalletScreenshot,
      buttonText: context.i18n.button_continue,
      onPressed: () {},
    );
  }
}
