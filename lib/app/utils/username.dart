import 'package:flutter/material.dart';
import 'package:ice/l10n/i10n.dart';

String prefixUsername({
  required String? username,
  required BuildContext context,
}) {
  final bool rtl = isRTL(context);
  final String lUsername = username ?? '';

  if (lUsername.isNotEmpty) {
    return rtl ? '$lUsername@' : '@$lUsername';
  } else {
    return lUsername;
  }
}
