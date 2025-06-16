// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/generated/assets.gen.dart';

enum TwoFaType {
  auth,
  email,
  sms;

  String getDisplayName(BuildContext context) {
    return switch (this) {
      TwoFaType.auth => context.i18n.two_fa_auth,
      TwoFaType.email => context.i18n.two_fa_email,
      TwoFaType.sms => context.i18n.two_fa_sms,
    };
  }

  String get iconAsset {
    return switch (this) {
      TwoFaType.auth => Assets.svgIconLoginAuthcode,
      TwoFaType.email => Assets.svgIconFieldEmail,
      TwoFaType.sms => Assets.svgIconLoginSmscode,
    };
  }
}
