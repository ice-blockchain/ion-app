import 'package:flutter/material.dart';
import 'package:ice/app/components/modal_sheets/simple_modal_sheet.dart';
import 'package:ice/generated/assets.gen.dart';

class ScreenshotSecurityAlert extends StatelessWidget {
  const ScreenshotSecurityAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleModalSheet(
      title: 'Screenshots aren’t secure',
      description:
          'Anyone who has access to your keys can use your assets. We recommend writing with your hands.',
      iconAsset: Assets.images.icons.actionWalletScreenshot,
      buttonText: 'Continue',
      onPressed: () {},
    );
  }
}
