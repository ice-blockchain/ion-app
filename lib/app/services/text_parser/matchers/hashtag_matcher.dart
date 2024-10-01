// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/services/text_parser/text_matcher.dart';

class HashtagMatcher extends TextMatcher {
  const HashtagMatcher([
    super.pattern = '#[A-Za-z0-9_]+',
  ]);
}
