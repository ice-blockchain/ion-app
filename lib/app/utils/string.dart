// SPDX-License-Identifier: ice License 1.0

extension StringExtensions on String {
  static final RegExp emojiOnlyRegExp = RegExp(
    r'^(?:\p{Emoji}|\p{Emoji_Presentation}|\p{Extended_Pictographic})(?!\d)$',
    unicode: true,
  );

  bool get isEmoji {
    if (RegExp(r'^\d+$').hasMatch(this)) return false;
    return emojiOnlyRegExp.hasMatch(this);
  }

  String capitalize() {
    if (isEmpty) return this;
    if (length == 1) return toUpperCase();
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

/// Replaces placeholders in the format `{{key}}` within the [input] string
/// using corresponding values from the [placeholders] map.
///
/// Example:
/// ```dart
/// final template = 'Hello, {{name}}! Welcome to {{place}}.';
/// final result = replacePlaceholders(template, {
///   'name': 'Alice',
///   'place': 'Wonderland',
/// });
/// print(result); // Hello, Alice! Welcome to Wonderland.
/// ```
///
String replacePlaceholders(String input, Map<String, String> placeholders) {
  final regex = RegExp('{{(.*?)}}');
  return input.replaceAllMapped(regex, (match) {
    final key = match.group(1)?.trim();
    return placeholders[key] ?? match.group(0)!;
  });
}
