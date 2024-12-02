// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/services/text_parser/text_match.dart';
import 'package:ion/app/services/text_parser/text_matcher.dart';

/// A builder class that constructs a `TextSpan` from a list of `TextMatch` objects.
///
/// The `TextSpanBuilder` allows you to customize text styles for different types of matches
/// (e.g., hashtags, mentions, URLs) and handle tap events on those matches.
///
/// ### Example Usage:
///
/// ```dart
/// final parser = TextParser(matchers: [
///   const HashtagMatcher(),
///   const MentionMatcher(),
///   const UrlMatcher(),
/// ]);
///
/// final matches = parser.parse(someText);
///
/// final textSpanBuilder = TextSpanBuilder(
///   defaultStyle: TextStyle(color: Colors.black),
///   matcherStyles: {
///     const HashtagMatcher(): TextStyle(color: Colors.blue),
///     const MentionMatcher(): TextStyle(color: Colors.green),
///     const UrlMatcher(): TextStyle(color: Colors.red),
///   },
/// );
///
/// final textSpan = textSpanBuilder.build(
///   matches,
///   onTap: (match) {
///     // Handle tap on match
///     print('Tapped on: ${match.text}');
///   },
/// );
///
/// // Don't forget to dispose of the textSpanBuilder when done
/// textSpanBuilder.dispose();
/// ```
class TextSpanBuilder {
  /// Creates a new instance of `TextSpanBuilder`.
  ///
  /// - [defaultStyle]: The default `TextStyle` to apply to text segments that do not have a specific style.
  /// - [matcherStyles]: A map of `TextMatcher` instances to their corresponding `TextStyle`s.
  ///   This allows you to specify custom styles for different matchers.
  ///
  /// If [matcherStyles] is not provided, it defaults to an empty map.
  TextSpanBuilder({
    this.defaultStyle,
    Map<TextMatcher, TextStyle?>? matcherStyles,
  }) : matcherStyles = matcherStyles ?? {};

  /// The default text style to apply to text segments without a specific style.
  final TextStyle? defaultStyle;

  /// A map associating `TextMatcher` instances with their custom text styles.
  ///
  /// Use this to define custom styles for specific types of matches, such as hashtags or mentions.
  final Map<TextMatcher, TextStyle?> matcherStyles;

  /// A list of `GestureRecognizer`s used for handling tap events on text segments.
  ///
  /// These need to be disposed of when no longer needed to prevent memory leaks.
  final List<GestureRecognizer> _gestureRecognizers = [];

  /// Disposes all `GestureRecognizer`s to prevent memory leaks.
  ///
  /// Call this method when the `TextSpanBuilder` is no longer needed, typically in the
  /// `dispose` method of a `StatefulWidget` or using a hook in a `HookWidget`.
  void dispose() {
    for (final recognizer in _gestureRecognizers) {
      recognizer.dispose();
    }
    _gestureRecognizers.clear();
  }

  /// Builds a `TextSpan` from a list of `TextMatch` objects.
  ///
  /// - [matches]: The list of `TextMatch` objects obtained from parsing the text.
  /// - [excludeMatchers]: A set of `TextMatcher`s to exclude from the resulting `TextSpan`.
  ///   Any matches associated with these matchers will be skipped.
  /// - [onTap]: An optional callback function invoked when a user taps on a matched text segment.
  ///   The callback receives the `TextMatch` object of the tapped segment.
  ///
  /// Returns a `TextSpan` that can be used in a `RichText` widget or similar.
  TextSpan build(
    List<TextMatch> matches, {
    Set<TextMatcher>? excludeMatchers,
    void Function(TextMatch match)? onTap,
  }) {
    final children = <TextSpan>[];

    for (final match in matches) {
      // Skip matches associated with excluded matchers
      if (excludeMatchers != null && excludeMatchers.contains(match.matcher)) {
        continue;
      }

      // Determine the style for the current match
      final style = matcherStyles[match.matcher] ?? defaultStyle;
      GestureRecognizer? recognizer;

      if (onTap != null) {
        // Check if the matcher is one of the recognized types for tap handling
        final recognizedMatchers = match.matcher is HashtagMatcher ||
            match.matcher is MentionMatcher ||
            match.matcher is UrlMatcher;

        if (recognizedMatchers) {
          // Create a TapGestureRecognizer to handle taps
          recognizer = TapGestureRecognizer()..onTap = () => onTap(match);
          _gestureRecognizers.add(recognizer);
        }
      }

      // Add the TextSpan for the current match
      children.add(
        TextSpan(
          text: match.text,
          style: style,
          recognizer: recognizer,
        ),
      );
    }

    // Return a TextSpan containing all child TextSpans
    return TextSpan(children: children);
  }

  /// Creates a map of default styles for the provided matchers.
  static Map<TextMatcher, TextStyle> defaultMatchersStyles(
    BuildContext context, {
    TextStyle? style,
  }) {
    final defaultStyle = style ?? context.theme.appTextThemes.body2;

    return {
      const HashtagMatcher(): defaultStyle.copyWith(
        color: context.theme.appColors.darkBlue,
      ),
      const UrlMatcher(): defaultStyle.copyWith(
        color: context.theme.appColors.darkBlue,
      ),
      const MentionMatcher(): defaultStyle.copyWith(
        color: context.theme.appColors.darkBlue,
      ),
    };
  }
}
