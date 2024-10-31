// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/text_parser/text_matcher.dart';

class HashtagMatcher extends TextMatcher {
  const HashtagMatcher([
    super.pattern = r'#[^\s]+',
  ]);
}
