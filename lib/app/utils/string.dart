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
