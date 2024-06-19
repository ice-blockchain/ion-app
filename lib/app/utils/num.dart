import 'package:intl/intl.dart';

String formatDouble(double value) {
  final formatter = NumberFormat('#,##0.00', 'en_US');
  return formatter.format(value);
}

/// A number format for compact representations, e.g. "1.2M" instead
/// of "1,200,000".
String formatDoubleCompact(num value) {
  return NumberFormat.compact().format(value);
}

String formatToCurrency(double value, [String? symbol]) {
  return NumberFormat.currency(symbol: symbol ?? r'$', decimalDigits: 2)
      .format(value);
}
