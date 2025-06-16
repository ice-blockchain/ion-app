// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/generated/assets.gen.dart';

enum RecoveryKeyProperty {
  identityKeyName,
  recoveryKeyId,
  recoveryCode;

  String getDisplayName(BuildContext context) {
    return switch (this) {
      RecoveryKeyProperty.identityKeyName => context.i18n.common_identity_key_name,
      RecoveryKeyProperty.recoveryKeyId => context.i18n.restore_identity_creds_recovery_key,
      RecoveryKeyProperty.recoveryCode => context.i18n.restore_identity_creds_recovery_code,
    };
  }

  String get iconAsset {
    return switch (this) {
      RecoveryKeyProperty.identityKeyName => Assets.svgIconIdentitykey,
      RecoveryKeyProperty.recoveryKeyId => Assets.svgIconChannelPrivate,
      RecoveryKeyProperty.recoveryCode => Assets.svgIconCode4,
    };
  }
}
