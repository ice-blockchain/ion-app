// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/services/text_parser/text_match.dart';
import 'package:ice/app/services/text_parser/text_matcher.dart';

class TextParser {
  TextParser({
    required this.matchers,
  }) : assert(
          matchers.isNotEmpty,
          'At least one matcher must be specified.',
        ) {
    /// Why groupIndexStart is 2?
    /// 0 - is the match of the pattern
    /// then 1 + index of the pattern in the pattern list
    ///   + total number of groups in prev patterns is match again
    ///   nulls are in between
    /// then groups of this matched pattern one by one
    ///
    /// Example:
    /// ```dart
    /// final reg = RegExp('(a(a))|(bb)');
    /// final matches = reg.allMatches('ff aa bb aa cc');
    /// ```
    /// matches will be:
    /// [aa, aa, a]
    /// [bb, null, null, bb]
    ///
    /// So if we have groups even inside the first matcher,
    /// they will start from index 2.

    var groupIndexStart = 2;
    final patterns = <String>[];

    for (var i = 0; i < matchers.length; i++) {
      final pattern = matchers[i].pattern;
      final groupName = '__parser__$i';
      final groupCount = RegExp('$pattern|.*').firstMatch('')?.groupCount ?? 0;

      patterns.add('(?<$groupName>$pattern)');
      _matcherGroupNames.add(groupName);
      _matcherGroupRanges.add(List.generate(groupCount, (i) => i + groupIndexStart));

      groupIndexStart += groupCount + 1;
    }

    _pattern = patterns.join('|');
  }

  final List<TextMatcher> matchers;

  final List<String> _matcherGroupNames = [];

  final List<List<int>> _matcherGroupRanges = [];

  late String _pattern;

  List<TextMatch> parse(String text, {bool onlyMatches = false}) {
    final matches = RegExp(_pattern).allMatches(text);

    final result = <TextMatch>[];
    var offset = 0;

    for (final match in matches) {
      if (!onlyMatches && match.start > offset) {
        final substring = text.substring(offset, match.start);
        result.add(TextMatch(substring, offset: offset));
      }

      final substring = text.substring(match.start, match.end);

      final matcherIndex =
          _matcherGroupNames.indexWhere((name) => match.namedGroup(name) == substring);

      if (matcherIndex > -1) {
        result.add(
          TextMatch(
            substring,
            offset: match.start,
            matcherType: matchers[matcherIndex].runtimeType,
            matcherIndex: matcherIndex,
            groups: match.groups(_matcherGroupRanges[matcherIndex]),
          ),
        );
      }

      offset = match.end;
    }

    if (!onlyMatches && offset < text.length) {
      final substring = text.substring(offset);
      result.add(TextMatch(substring, offset: offset));
    }

    return result;
  }
}
