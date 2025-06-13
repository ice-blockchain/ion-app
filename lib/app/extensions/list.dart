// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:collection/collection.dart';

extension ListExtension<T> on List<T>? {
  List<T> get emptyOrValue => this ?? <T>[];

  Type get genericType => T;
}

extension ListRandomExtension<T> on List<T> {
  T get random {
    return this[Random().nextInt(length)];
  }
}

extension KindListExtensions on List<List<String>> {
  static const _deepEquality = DeepCollectionEquality();

  bool equalsDeep(List<List<String>> other) {
    return _deepEquality.equals(this, other);
  }

  bool containsKind(List<String> targetKind) {
    return any((kind) => const ListEquality<String>().equals(kind, targetKind));
  }
}
