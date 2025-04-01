double? parseAmount(String amount) {
  return double.tryParse(amount.replaceAll(',', '.'));
}
