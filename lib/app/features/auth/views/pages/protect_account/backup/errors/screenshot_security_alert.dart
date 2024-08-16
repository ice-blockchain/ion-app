import 'package:flutter/material.dart';
import 'package:ice/app/components/modal_sheets/simple_modal_sheet.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class ScreenshotSecurityAlert extends StatelessWidget {
  const ScreenshotSecurityAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleModalSheet(
      title: context.i18n.error_screenshots_arent_secure_title,
      description: context.i18n.error_screenshots_arent_secure_description,
      iconAsset: Assets.images.icons.actionWalletScreenshot,
      buttonText: context.i18n.button_continue,
      onPressed: () {},
    );
  }
}
