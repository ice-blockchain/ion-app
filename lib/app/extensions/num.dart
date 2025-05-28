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

extension SizeExtension on double {
  double get s {
    return w;
  }
}

extension Timestamp on int {
  DateTime get toDateTime {
    if (toString().length <= 10) {
      // If it's less than or equal to 10 digits, assume it's in seconds
      return DateTime.fromMillisecondsSinceEpoch(this * 1000);
    }
    return DateTime.fromMicrosecondsSinceEpoch(this);
  }
}
