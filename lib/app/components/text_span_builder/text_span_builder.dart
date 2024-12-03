// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/services/text_parser/text_match.dart';
import 'package:ion/app/services/text_parser/text_matcher.dart';

/// Constructs TextSpan from TextMatch objects with customizable styles and tap handling.
class TextSpanBuilder {
  TextSpanBuilder({
    this.defaultStyle,
    Map<TextMatcher, TextStyle?>? matcherStyles,
  }) : matcherStyles = matcherStyles ?? {};

  final TextStyle? defaultStyle;

  final Map<TextMatcher, TextStyle?> matcherStyles;

  final List<GestureRecognizer> _gestureRecognizers = [];

  /// Disposes all GestureRecognizers to prevent memory leaks
  void dispose() {
    for (final recognizer in _gestureRecognizers) {
      recognizer.dispose();
    }
    _gestureRecognizers.clear();
  }

  /// Builds a TextSpan from TextMatch objects with optional tap handling
  TextSpan build(
    List<TextMatch> matches, {
    Set<TextMatcher>? excludeMatchers,
    void Function(TextMatch match)? onTap,
  }) {
    final children = <TextSpan>[];

    for (final match in matches) {
      if (excludeMatchers != null && excludeMatchers.contains(match.matcher)) {
        continue;
      }

      final style = matcherStyles[match.matcher] ?? defaultStyle;
      GestureRecognizer? recognizer;

      if (onTap != null) {
        final recognizedMatchers = match.matcher is HashtagMatcher ||
            match.matcher is MentionMatcher ||
            match.matcher is UrlMatcher;

        if (recognizedMatchers) {
          recognizer = TapGestureRecognizer()..onTap = () => onTap(match);
          _gestureRecognizers.add(recognizer);
        }
      }

      children.add(
        TextSpan(
          text: match.text,
          style: style,
          recognizer: recognizer,
        ),
      );
    }

    return TextSpan(children: children);
  }

  /// Creates default styles map for matchers
  static Map<TextMatcher, TextStyle> defaultMatchersStyles(
    BuildContext context, {
    TextStyle? style,
  }) {
    final defaultStyle = style ??
        context.theme.appTextThemes.body2.copyWith(
          color: context.theme.appColors.darkBlue,
        );

    return {
      const HashtagMatcher(): defaultStyle,
      const UrlMatcher(): defaultStyle,
      const MentionMatcher(): defaultStyle,
    };
  }
}
