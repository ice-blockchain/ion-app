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
  String get pattern => r'\b(?:'
      // scheme or www with host (fallback allowed)
      '(?:'
      r'(?:[a-z][a-z0-9+\-.]*):\/\/' // scheme://
      r'|www\.' // or www.
      ')'
      r'(?:[^@\s]+@)?' // optional auth
      r'(?:(?:(?!-)[A-Za-z0-9-]+(?<!-)\.)+' // labels with dots
      '(?:com|net|org|info|biz|gov|edu|mil|int|arpa|io|ai|app|dev|xyz|online|site|tech|blog|store|news|shop|club|us|uk|ca|de|fr|cn|jp|ru|br|in|au|es|it|nl|se|no|fi|dk|be|ch|at|pl|cz|sk|pt|gr|tr|kr|sg|hk|tw|mx|ar|za)' // explicit TLD list
      '|(?!-)[A-Za-z0-9-]{2,}(?<!-))' // or fallback host (like localhost)
      '|'
      // bare domain with explicit TLD only
      r'(?:[A-Za-z0-9-]+\.)+' // labels with dots
      '(?:com|net|org|info|biz|gov|edu|mil|int|arpa|io|ai|app|dev|xyz|online|site|tech|blog|store|news|shop|club|us|uk|ca|de|fr|cn|jp|ru|br|in|au|es|it|nl|se|no|fi|dk|be|ch|at|pl|cz|sk|pt|gr|tr|kr|sg|hk|tw|mx|ar|za)' // explicit TLD list
      ')'
      r'(?::\d{2,5})?' // optional port
      r'(?:\/[^\s!?.,;:]*[A-Za-z0-9\/])?' // optional path
      r'(?:\?[^\s!?.,;:]*[A-Za-z0-9%_=&-])?' // optional query params ending in valid char
      r'\b'; // word boundary
}

class CashtagMatcher extends TextMatcher {
  const CashtagMatcher();

  @override
  String get pattern => r'\$(?=[\w-]*[A-Za-z])\w+(?:-\w+)*\b';
}
