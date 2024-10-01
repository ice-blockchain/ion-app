// SPDX-License-Identifier: ice License 1.0

extension ListExtension<T> on List<T>? {
  List<T> get emptyOrValue => this ?? <T>[];

  Type get genericType => T;
}
