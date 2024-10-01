// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/generated/assets.gen.dart';

enum RecoveryKeys {
  identityKeyName,
  recoveryKeyId,
  recoveryCode;

  String getDisplayName(BuildContext context) {
    return switch (this) {
      RecoveryKeys.identityKeyName => context.i18n.common_identity_key_name,
      RecoveryKeys.recoveryKeyId => context.i18n.restore_identity_creds_recovery_key,
      RecoveryKeys.recoveryCode => context.i18n.restore_identity_creds_recovery_code,
    };
  }

  String get iconAsset {
    return switch (this) {
      RecoveryKeys.identityKeyName => Assets.svg.iconIdentitykey,
      RecoveryKeys.recoveryKeyId => Assets.svg.iconChannelPrivate,
      RecoveryKeys.recoveryCode => Assets.svg.iconCode4,
    };
  }
}
