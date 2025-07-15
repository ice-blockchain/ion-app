// SPDX-License-Identifier: ice License 1.0

sealed class TextMatcher {
  const TextMatcher();

  String get pattern;
}

class MentionMatcher extends TextMatcher {
  const MentionMatcher();

  @override
  String get pattern => r'@[A-Za-z0-9.]+\b';
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
      r'(?<!@)(\b((?:https?:\/\/)?(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,6}(?::\d+)?(?:[-A-Za-z0-9()@:%_+.~#?&\/=]*)?)\b)';
}

class CashtagMatcher extends TextMatcher {
  const CashtagMatcher();

  @override
  String get pattern => r'\$(?=[\w-]*[A-Za-z])\w+(?:-\w+)*\b';
}
