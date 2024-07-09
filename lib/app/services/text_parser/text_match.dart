import 'package:ice/app/services/text_parser/text_matcher.dart';

class TextMatch {
  const TextMatch(
    this.text, {
    this.groups = const [],
    this.matcherType = TextMatcher,
    this.matcherIndex,
    this.offset = 0,
  });

  final String text;

  final List<String?> groups;

  final Type matcherType;

  final int? matcherIndex;

  final int offset;

  @override
  String toString() {
    return 'TextMatch(text: $text, groups: $groups, matcherType: $matcherType, '
        'matcherIndex: $matcherIndex, offset: $offset)';
  }
}
