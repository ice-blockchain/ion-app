import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/generated/assets.gen.dart';

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
      TwoFaType.auth => Assets.images.icons.iconLoginAuthcode,
      TwoFaType.email => Assets.images.icons.iconFieldEmail,
      TwoFaType.sms => Assets.images.icons.iconLoginSmscode,
    };
  }
}
