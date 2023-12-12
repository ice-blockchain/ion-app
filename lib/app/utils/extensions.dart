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
            noNullVal.truncateToDouble() == noNullVal
                ? 0
                : roundToDecimalsCount,
          );
  }
}

extension DoubleExtension on double {
  double get s {
    return w;
  }
}

extension BooleanExtension on bool? {
  bool get falseOrValue {
    return this ?? false;
  }
}

extension StringExtension on String? {
  String get emptyOrValue {
    return this ?? '';
  }

  bool get isEmpty {
    return emptyOrValue.isEmpty;
  }

  bool get isNotEmpty {
    return emptyOrValue.isNotEmpty;
  }
}

extension ListExtension<T> on List<T>? {
  List<T> get emptyOrValue => this ?? <T>[];

  Type get genericType => T;
}
