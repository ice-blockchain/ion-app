// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/services/text_parser/matchers/hashtag_matcher.dart';
import 'package:ion/app/services/text_parser/matchers/mention_matcher.dart';
import 'package:ion/app/services/text_parser/text_match.dart';
import 'package:ion/app/services/text_parser/text_parser.dart';

class RichTextWithHighlights extends HookConsumerWidget {
  const RichTextWithHighlights({
    required this.text,
    required this.style,
    this.onHashtagTap,
    this.onMentionTap,
    super.key,
  });

  final String text;
  final TextStyle style;
  final void Function(String hashtag)? onHashtagTap;
  final void Function(String mention)? onMentionTap;

  TextSpan _buildAboutTextSpan(
    String text,
    BuildContext context,
    List<MapEntry<TextMatch, TapGestureRecognizer>> entries,
  ) {
    final children = <TextSpan>[];
    var lastMatchEnd = 0;

    for (final entry in entries) {
      final match = entry.key;
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
          style: style.copyWith(
            color: context.theme.appColors.darkBlue,
          ),
          recognizer: entry.value,
        ),
      );

      lastMatchEnd = match.offset + match.text.length;
    }

    if (lastMatchEnd < text.length) {
      children.add(
        TextSpan(
          text: text.substring(lastMatchEnd),
          style: style,
        ),
      );
    }

    return TextSpan(children: children);
  }

  GestureTapCallback? getCallback(TextMatch match) {
    if (match.matcherType == HashtagMatcher) {
      return () => onHashtagTap?.call(match.text);
    }
    if (match.matcherType == MentionMatcher) {
      return () => onMentionTap?.call(match.text);
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAndRecognizers = useState<List<MapEntry<TextMatch, TapGestureRecognizer>>>([]);

    useEffect(
      () {
        final parser = TextParser(matchers: [const HashtagMatcher(), const MentionMatcher()]);
        final matches = parser.parse(text);

        final newEntries = matches
            .where(
          (match) => match.matcherType == HashtagMatcher || match.matcherType == MentionMatcher,
        )
            .map((match) {
          final recognizer = TapGestureRecognizer()..onTap = getCallback(match);
          return MapEntry(match, recognizer);
        }).toList();

        matchesAndRecognizers.value = newEntries;

        return () {
          for (final entry in matchesAndRecognizers.value) {
            entry.value.dispose();
          }
        };
      },
      [text],
    );

    return RichText(
      text: _buildAboutTextSpan(text, context, matchesAndRecognizers.value),
      textScaler: MediaQuery.textScalerOf(context),
    );
  }
}
