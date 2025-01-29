// SPDX-License-Identifier: ice License 1.0

sealed class TextMatcher {
  const TextMatcher();

  String get pattern;
}

class MentionMatcher extends TextMatcher {
  const MentionMatcher();

  @override
  String get pattern => r'@\w+\b';
}

class HashtagMatcher extends TextMatcher {
  const HashtagMatcher();

  @override
  String get pattern => r'#[^\s]+';
}

class UrlMatcher extends TextMatcher {
  const UrlMatcher();

  @override
  String get pattern =>
      r'https?://(www\.)?[-a-zA-Z0-9@:%._+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}(?:[-a-zA-Z0-9()@:%_+.~#?&//=]*)\b';
}

class CashtagMatcher extends TextMatcher {
  const CashtagMatcher();

  @override
  String get pattern => r'\$[A-Z]+\b';
}
