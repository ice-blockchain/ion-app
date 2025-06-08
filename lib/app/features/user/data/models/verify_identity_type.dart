// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';

enum VerifyIdentityType {
  passkey,
  password,
  biometrics;

  String getTitle(BuildContext context) {
    switch (this) {
      case VerifyIdentityType.passkey:
        return context.i18n.passkeys_prompt_title;
      case VerifyIdentityType.password:
        return context.i18n.verify_with_password_title;
      case VerifyIdentityType.biometrics:
        return context.i18n.verify_with_biometrics_title;
    }
  }

  String getDesc(BuildContext context) {
    switch (this) {
      case VerifyIdentityType.passkey:
        return context.i18n.passkeys_prompt_description;
      case VerifyIdentityType.password:
        return context.i18n.verify_with_password_prompt_desc;
      case VerifyIdentityType.biometrics:
        return context.i18n.passkeys_prompt_description;
    }
  }
}
