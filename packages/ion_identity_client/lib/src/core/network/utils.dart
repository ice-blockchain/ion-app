// SPDX-License-Identifier: ice License 1.0

List<T> parseList<T>(
  dynamic input, {
  required T Function(Map<String, dynamic>) fromJson,
}) {
  if (input is List && input.every((e) => e is Map<String, dynamic>)) {
    return input.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }
  return [];
}

T parseJsonObject<T>(
  dynamic input, {
  required T Function(Map<String, dynamic>) fromJson,
}) {
  return switch (input) {
    null => fromJson({}),
    Map<String, dynamic>() => fromJson(input),
    _ => throw FormatException(
        'Expected a Map<String, dynamic>, but got: ${input.runtimeType}',
      ),
  };
}
