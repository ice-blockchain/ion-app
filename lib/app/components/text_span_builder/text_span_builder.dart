// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/router/app_routes.gr.dart';
import 'package:ion/app/services/browser/browser.dart';
import 'package:ion/app/services/deep_link/deep_link_service.r.dart';
import 'package:ion/app/services/text_parser/model/text_match.f.dart';
import 'package:ion/app/services/text_parser/model/text_matcher.dart';
import 'package:ion/app/utils/url.dart';

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
            match.matcher is UrlMatcher ||
            match.matcher is CashtagMatcher;

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
      const CashtagMatcher(): defaultStyle,
    };
  }

  /// Add default onTap for all matchers
  static void defaultOnTap(
    BuildContext context,
    WidgetRef ref, {
    required TextMatch match,
  }) {
    if (match.matcher is UrlMatcher) {
      if (DeepLinkService.urlRegex.hasMatch(match.text)) {
        ref.read(deepLinkServiceProvider).resolveDeeplink(match.text);
      } else {
        openUrlInAppBrowser(normalizeUrl(match.text));
      }
    }

    if (match.matcher is HashtagMatcher || match.matcher is CashtagMatcher) {
      FeedAdvancedSearchRoute(query: match.text).push<void>(context);
    }
  }
}
