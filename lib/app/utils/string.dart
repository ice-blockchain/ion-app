// SPDX-License-Identifier: ice License 1.0

extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    if (length == 1) return toUpperCase();
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
