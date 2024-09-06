import 'package:flutter/material.dart';
import 'package:ice/app/components/modal_sheets/simple_modal_sheet.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class RecoveryKeysErrorAlert extends StatelessWidget {
  const RecoveryKeysErrorAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleModalSheet.alert(
      title: context.i18n.error_recovery_keys_title,
      description: context.i18n.error_recovery_keys_description,
      iconAsset: Assets.images.icons.actionWalletKeyserror,
      buttonText: context.i18n.button_try_again,
      onPressed: () {},
    );
  }
}
