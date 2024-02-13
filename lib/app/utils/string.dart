import 'package:intl/intl.dart';

String formatDouble(double value) {
  final NumberFormat formatter = NumberFormat('#,##0.00', 'en_US');
  return formatter.format(value);
}
