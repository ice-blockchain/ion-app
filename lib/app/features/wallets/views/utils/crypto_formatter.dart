import 'package:ion/app/utils/num.dart';

String formatCrypto(double value, [String? currency]) {
  final formatted = formatDouble(value, maximumFractionDigits: 10);

  if (currency != null) return '$formatted $currency';

  return formatted;
}
