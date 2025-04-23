// SPDX-License-Identifier: ice License 1.0

String trimPrefix(
  String value, {
  String separator = ':',
}) {
  final parts = value.split(separator);
  if (parts.length == 1) {
    return parts.first;
  }
  return parts.skip(1).join(separator);
}
