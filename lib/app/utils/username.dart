import 'package:flutter/material.dart';
import 'package:ice/l10n/i10n.dart';

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
