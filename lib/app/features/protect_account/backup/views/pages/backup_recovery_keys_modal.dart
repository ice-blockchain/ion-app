// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/modal_sheets/simple_modal_sheet.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/router/app_routes.gr.dart';
import 'package:ion/generated/assets.gen.dart';

class BackupRecoveryKeysModal extends StatelessWidget {
  const BackupRecoveryKeysModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleModalSheet.info(
      title: context.i18n.secure_your_recovery_keys_title,
      description: context.i18n.secure_your_recovery_keys_description,
      iconAsset: Assets.svg.actionWalletLock,
      button: ScreenSideOffset.large(
        child: Button(
          mainAxisSize: MainAxisSize.max,
          label: Text(context.i18n.button_lets_start),
          onPressed: () => CreateRecoveryKeyRoute().push<void>(context),
          trailingIcon: Assets.svg.iconButtonNext.icon(
            color: context.theme.appColors.onPrimaryAccent,
          ),
        ),
      ),
    );
  }
}
