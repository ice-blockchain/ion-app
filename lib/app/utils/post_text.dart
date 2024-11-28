// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/text_parser/text_match.dart';

// TODO: Temp impl, ask how to extract multiple text content
String extractPostText(List<TextMatch> content, {Type? excludeMatcherType}) {
  final buffer = StringBuffer();
  for (final match in content) {
    if (excludeMatcherType == null || match.matcherType != excludeMatcherType) {
      buffer.write(match.text);
    }
  }
  return buffer.toString();
}
