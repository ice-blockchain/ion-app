// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_screenutil/flutter_screenutil.dart';

extension NumExtension on num? {
  num get zeroOrValue {
    return this ?? 0.0;
  }
}

extension IntNullableExtension on int? {
  int get zeroOrValue {
    return this ?? 0;
  }
}

extension DoubleNullableExtension on double? {
  double get zeroOrValue {
    return this ?? 0.0;
  }

  String removeDecimalZeroFormat({int roundToDecimalsCount = 2}) {
    final num noNullVal = zeroOrValue;
    return roundToDecimalsCount == 0
        ? noNullVal.truncateToDouble() == noNullVal
            ? noNullVal.toInt().toString()
            : toString()
        : noNullVal.toStringAsFixed(
            noNullVal.truncateToDouble() == noNullVal ? 0 : roundToDecimalsCount,
          );
  }
}

extension SizeExtension on num {
  double get s {
    return w;
  }
}

extension Timestamp on int {
  DateTime get toDateTime {
    return switch (toString().length) {
      // If the timestamp is 10 digits, it's in seconds
      10 => DateTime.fromMillisecondsSinceEpoch(this * 1000),
      // If the timestamp is 13 digits, it's in milliseconds
      13 => DateTime.fromMillisecondsSinceEpoch(this),
      // If the timestamp is 16 digits, assume it's in microseconds
      16 => DateTime.fromMicrosecondsSinceEpoch(this),
      _ => throw FormatException(
          'Invalid timestamp format: ${toString()} length: ${toString().length}',
        ),
    };
  }
}
