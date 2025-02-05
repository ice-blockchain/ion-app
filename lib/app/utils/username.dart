// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/l10n/i10n.dart';

String prefixUsername({
  required String? username,
  required BuildContext context,
}) {
  final rtl = isRTL(context);
  final lUsername = username ?? '';

  if (lUsername.isNotEmpty) {
    return rtl ? '$lUsername@' : '@$lUsername';
  } else {
    return lUsername;
  }
}

//create extension for String prefixUsername
extension UsernamePrefix on String {
  String formatUsername({
    required BuildContext context,
  }) {
    return prefixUsername(username: this, context: context);
  }
}
