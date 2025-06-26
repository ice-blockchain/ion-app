// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/services/text_parser/model/text_matcher.dart';

part 'text_match.f.freezed.dart';

@freezed
class TextMatch with _$TextMatch {
  const factory TextMatch(
    String text, {
    @Default([]) List<String?> groups,
    TextMatcher? matcher,
    int? matcherIndex,
    @Default(0) int offset,
  }) = _TextMatch;
}
