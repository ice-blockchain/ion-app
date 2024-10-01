// SPDX-License-Identifier: ice License 1.0

extension BooleanExtension on bool? {
  bool get falseOrValue {
    return this ?? false;
  }
}
