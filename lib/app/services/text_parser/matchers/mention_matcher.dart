// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/text_parser/text_matcher.dart';

class MentionMatcher extends TextMatcher {
  const MentionMatcher([
    super.pattern = r'@[^\s]+',
  ]);
}
