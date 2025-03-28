import 'dart:math';

import 'package:ion/app/services/logger/logger.dart';

double parseCryptoAmount(String input, int decimals) {
  try {
    final parsed = double.parse(input);
    return parsed / pow(10, decimals);
  } on FormatException catch (_) {
    Logger.error('Failed to parse coins amount with `$input` value.');
    return 0;
  }
}
