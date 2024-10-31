// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/services/text_parser/matchers/hashtag_matcher.dart';
import 'package:ion/app/services/text_parser/matchers/mention_matcher.dart';
import 'package:ion/app/services/text_parser/text_parser.dart';

class TextEditingWithHighlightsController extends TextEditingController {
  TextEditingWithHighlightsController({super.text});

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    required bool withComposing,
    TextStyle? style,
  }) {
    final text = value.text;
    final parser = TextParser(matchers: [const HashtagMatcher(), const MentionMatcher()]);
    final matches = parser.parse(text);

    final children = <TextSpan>[];
    var lastMatchEnd = 0;

    for (final match in matches) {
      if (match.matcherType == HashtagMatcher || match.matcherType == MentionMatcher) {
        if (match.offset > lastMatchEnd) {
          children.add(
            TextSpan(
              text: text.substring(lastMatchEnd, match.offset),
              style: style,
            ),
          );
        }

        children.add(
          TextSpan(
            text: match.text,
            style: style?.copyWith(
              color: context.theme.appColors.darkBlue,
            ),
          ),
        );

        lastMatchEnd = match.offset + match.text.length;
      }
    }

    if (lastMatchEnd < text.length) {
      children.add(
        TextSpan(
          text: text.substring(lastMatchEnd),
          style: style,
        ),
      );
    }

    return TextSpan(style: style, children: children);
  }
}
