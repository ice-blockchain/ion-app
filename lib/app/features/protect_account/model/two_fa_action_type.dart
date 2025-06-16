// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/generated/assets.gen.dart';

enum TwoFaActionType {
  emailDelete,
  emailUpdate,
  phoneDelete,
  phoneUpdate;

  String getSuccessDesc(BuildContext context) {
    return switch (this) {
      TwoFaActionType.emailDelete => context.i18n.two_fa_delete_email_success,
      TwoFaActionType.emailUpdate => context.i18n.two_fa_edit_email_success,
      TwoFaActionType.phoneDelete => context.i18n.two_fa_delete_phone_success,
      TwoFaActionType.phoneUpdate => context.i18n.two_fa_edit_phone_success,
    };
  }

  String get successIconAsset {
    return switch (this) {
      TwoFaActionType.emailDelete => Assets.svgIcon2faEmailVerification,
      TwoFaActionType.emailUpdate => Assets.svg.actionWalletConfirmemail,
      TwoFaActionType.phoneDelete => Assets.svgIcon2faEmailVerification,
      TwoFaActionType.phoneUpdate => Assets.svg.actionWalletConfirmphone,
    };
  }
}
