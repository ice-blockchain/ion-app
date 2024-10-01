// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/foundation.dart';

@immutable
abstract class TextMatcher {
  const TextMatcher(this.pattern);

  final String pattern;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextMatcher && runtimeType == other.runtimeType && pattern == other.pattern;

  @override
  int get hashCode => Object.hash(runtimeType, pattern);

  @override
  String toString() => '$runtimeType(pattern: $pattern)';
}
