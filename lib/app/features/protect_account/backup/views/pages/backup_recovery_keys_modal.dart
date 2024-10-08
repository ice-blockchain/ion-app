// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/modal_sheets/simple_modal_sheet.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

class BackupRecoveryKeysModal extends StatelessWidget {
  const BackupRecoveryKeysModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleModalSheet.info(
      title: context.i18n.secure_your_recovery_keys_title,
      description: context.i18n.secure_your_recovery_keys_description,
      iconAsset: Assets.svg.actionWalletLock,
      buttonText: context.i18n.button_lets_start,
      onPressed: () => CreateRecoveryKeyRoute().push<void>(context),
    );
  }
}
