// SPDX-License-Identifier: ice License 1.0

double? parseAmount(String? amount) {
  return double.tryParse(amount?.replaceAll(',', '.') ?? '');
}
