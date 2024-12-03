// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/text_parser/text_matcher.dart';

class TextMatch {
  const TextMatch(
    this.text, {
    this.groups = const [],
    this.matcher,
    this.matcherIndex,
    this.offset = 0,
  });

  final String text;
  final List<String?> groups;
  final TextMatcher? matcher;
  final int? matcherIndex;
  final int offset;

  @override
  String toString() {
    return 'TextMatch(text: $text, groups: $groups, matcher: $matcher, '
        'matcherIndex: $matcherIndex, offset: $offset)';
  }
}
