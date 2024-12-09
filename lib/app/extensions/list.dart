// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

extension ListExtension<T> on List<T>? {
  List<T> get emptyOrValue => this ?? <T>[];

  Type get genericType => T;
}

extension ListRandomExtension<T> on List<T> {
  T get random {
    return this[Random().nextInt(length)];
  }
}
