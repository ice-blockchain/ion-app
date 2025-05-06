// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/services.dart';

TextInputFormatter decimalInputFormatter({required int maxDecimals}) {
  return FilteringTextInputFormatter.allow(RegExp('^\\d*\\,?\\d{0,$maxDecimals}'));
}
