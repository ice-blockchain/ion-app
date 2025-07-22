// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/utils/num.dart';

String formatCrypto(double value, [String? currency]) {
  final formatted = switch (value) {
    0.0 => formatDouble(value),
    _ when value >= 10 => _formatWithSmartTruncation(value, maxDecimals: 2, minDecimals: 2),
    // For values 1-9.99: max 6 decimals, min 2 decimals
    // Handle truncation for cases like 1.1234567 -> 1.123456 and 2.0000001 -> 2.00
    _ when value >= 1 => _formatWithSmartTruncation(value, maxDecimals: 6, minDecimals: 2),
    // For values < 1: max 6 decimals, min 2 decimals, but handle very small numbers
    _ when value < 1e-6 => _formatVerySmallNumber(value),
    _ => _formatWithSmartTruncation(value, maxDecimals: 6, minDecimals: 2),
  };

  if (currency != null) return '$formatted $currency';

  return formatted;
}

String _formatWithSmartTruncation(
  double value, {
  required int maxDecimals,
  required int minDecimals,
}) {
  final stringValue = value.toString();

  if (!stringValue.contains('.')) {
    // It's an integer, just format with minimum decimals
    return formatDouble(
      value,
      maximumFractionDigits: maxDecimals,
      minimumFractionDigits: minDecimals,
    );
  }

  final parts = stringValue.split('.');
  final integerPart = parts[0];
  var decimalPart = parts[1];

  // Truncate decimal part to maxDecimals if it's longer
  if (decimalPart.length > maxDecimals) {
    decimalPart = decimalPart.substring(0, maxDecimals);
  }

  // Pad with zeros to meet minimum decimals requirement
  final buffer = StringBuffer(decimalPart);
  while (buffer.length < minDecimals) {
    buffer.write('0');
  }
  decimalPart = buffer.toString();

  // Remove trailing zeros beyond minimum decimals
  while (decimalPart.length > minDecimals && decimalPart.endsWith('0')) {
    decimalPart = decimalPart.substring(0, decimalPart.length - 1);
  }

  final reconstructed = double.parse('$integerPart.$decimalPart');

  // Use formatDouble to get proper thousands separators
  return formatDouble(
    reconstructed,
    maximumFractionDigits: maxDecimals,
    minimumFractionDigits: minDecimals,
  );
}

String _formatVerySmallNumber(double value) {
  // Convert to string with high precision and remove trailing zeros
  final stringValue = value.toStringAsFixed(20).replaceAll(RegExp(r'0+$'), '');

  if (!stringValue.contains('.')) {
    return formatDouble(value);
  }

  final parts = stringValue.split('.');
  final decimalPart = parts[1];

  // Count consecutive zeros after decimal point
  var zeroCount = 0;
  for (var i = 0; i < decimalPart.length; i++) {
    if (decimalPart[i] == '0') {
      zeroCount++;
    } else {
      // Found the first non-zero digit
      final firstSignificantDigit = decimalPart[i];
      return '0.0($zeroCount)$firstSignificantDigit';
    }
  }

  // Fallback to regular formatting if no non-zero digits found
  return formatDouble(0);
}
