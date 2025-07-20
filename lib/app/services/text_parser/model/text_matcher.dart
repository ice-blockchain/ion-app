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
  String get pattern => r'\b(?:(?:[a-z][a-z0-9+\-.]*):\/\/|www\.)' // scheme:// or www.
      r'(?:[^@\s]+@)?' // optional auth
      r'(?:(?:(?!-)[A-Za-z0-9-]+(?<!-)\.)+[A-Za-z0-9-]{2,}|(?!-)[A-Za-z0-9-]{2,}(?<!-))' // host
      r'(?::\d{2,5})?' // optional port
      r'(?:\/[^\s!?.,;:]*[A-Za-z0-9\/])?'; // optional path ending in slash or alnum
}

class CashtagMatcher extends TextMatcher {
  const CashtagMatcher();

  @override
  String get pattern => r'\$(?=[\w-]*[A-Za-z])\w+(?:-\w+)*\b';
}
