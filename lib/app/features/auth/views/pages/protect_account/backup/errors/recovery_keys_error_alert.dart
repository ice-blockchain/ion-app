import 'package:flutter/material.dart';
import 'package:ice/app/components/modal_sheets/simple_modal_sheet.dart';
import 'package:ice/generated/assets.gen.dart';

class RecoveryKeysErrorAlert extends StatelessWidget {
  const RecoveryKeysErrorAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleModalSheet(
      title: 'Recovery keys error',
      description: 'You have entered incorrect data',
      iconAsset: Assets.images.identity.actionWalletKeyserror,
      buttonText: 'Try again',
      onPressed: () {},
    );
  }
}
