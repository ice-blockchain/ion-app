// SPDX-License-Identifier: ice License 1.0

class Predicates {
  Predicates._();

  static bool Function(String) startsWith(String prefix) =>
      (String value) => value.startsWith(prefix);
}
