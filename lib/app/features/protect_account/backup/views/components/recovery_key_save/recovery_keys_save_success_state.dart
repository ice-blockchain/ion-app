// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/card/rounded_card.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/protect_account/backup/views/components/recovery_key_option.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_client.dart';

class RecoveryKeysSaveSuccessState extends StatelessWidget {
  const RecoveryKeysSaveSuccessState({required this.recoveryData, super.key});

  final CreateRecoveryCredentialsSuccess recoveryData;

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return ScreenSideOffset.large(
      child: Column(
        children: [
          RecoveryKeyOption(
            title: locale.common_identity_key_name,
            iconAsset: Assets.svg.iconIdentitykey,
            subtitle: recoveryData.identityKeyName,
          ),
          SizedBox(height: 12.0.s),
          RecoveryKeyOption(
            title: locale.restore_identity_creds_recovery_key,
            iconAsset: Assets.svg.iconChannelPrivate,
            subtitle: recoveryData.recoveryKeyId,
          ),
          SizedBox(height: 12.0.s),
          RecoveryKeyOption(
            title: locale.restore_identity_creds_recovery_code,
            iconAsset: Assets.svg.iconCode4,
            subtitle: recoveryData.recoveryCode,
          ),
          SizedBox(height: 20.0.s),
          const _StoringKeysWarning(),
          SizedBox(height: 20.0.s),
          Button(
            mainAxisSize: MainAxisSize.max,
            label: Text(locale.button_continue),
            onPressed: () => ValidateRecoveryKeyRoute().push<void>(context),
          ),
        ],
      ),
    );
  }
}

class _StoringKeysWarning extends StatelessWidget {
  const _StoringKeysWarning();

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return RoundedCard.outlined(
      padding: EdgeInsets.symmetric(horizontal: 10.0.s),
      child: ListItem(
        contentPadding: EdgeInsets.zero,
        backgroundColor: context.theme.appColors.secondaryBackground,
        borderRadius: BorderRadius.all(
          Radius.circular(16.0.s),
        ),
        leading: Assets.svg.iconReport.icon(
          size: 20.0.s,
          color: context.theme.appColors.attentionRed,
        ),
        title: Text(
          locale.warning_avoid_storing_keys,
          style: context.theme.appTextThemes.caption.copyWith(
            color: context.theme.appColors.attentionRed,
          ),
          maxLines: 3,
        ),
      ),
    );
  }
}