// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:ion/app/components/text_editor/attributes.dart';
import 'package:ion/app/components/text_editor/custom_recognizer_builder.dart';
import 'package:ion/app/components/text_editor/utils/text_editor_styles.dart';
import 'package:ion/app/components/text_span_builder/text_span_builder.dart'
    as ion_text_span_builder;
import 'package:ion/app/services/text_parser/model/text_match.c.dart';
import 'package:ion/app/services/text_parser/model/text_matcher.dart';

/// Builds a rich TextSpan tree from Quill Delta, preserving formatting and recognizers.
class QuillTextSpanBuilder {
  /// Returns a TextSpan for the given Delta, using project styles and recognizers.
  static TextSpan buildFromDelta(
    Delta delta, {
    required BuildContext context,
    required DefaultStyles styles,
  }) {
    final children = <InlineSpan>[];
    for (final op in delta.toList()) {
      if (op.key != 'insert') continue;
      final data = op.data;
      final attrs = op.attributes ?? {};
      if (data is String) {
        final style = _applyTextAttributes(attrs, styles, context);
        final recognizer = _buildRecognizer(attrs, context, data);
        children.add(TextSpan(text: data, style: style, recognizer: recognizer));
      }
    }
    return TextSpan(children: children);
  }

  /// Applies text attributes (bold, italic, underline, link, hashtag, mention, cashtag) to style.
  static TextStyle _applyTextAttributes(
    Map<String, dynamic> attrs,
    DefaultStyles styles,
    BuildContext context,
  ) {
    var style = styles.paragraph?.style ?? const TextStyle();
    if (attrs['b'] == true) {
      style = style.merge(styles.bold);
    }
    if (attrs['i'] == true) {
      style = style.merge(styles.italic);
    }
    if (attrs['u'] == true) {
      style = style.merge(const TextStyle(decoration: TextDecoration.underline));
    }
    if (attrs.containsKey('a') && attrs['a'] != null) {
      style = style.merge(customTextStyleBuilder(Attribute.link, context));
    }
    if (attrs.containsKey('hashtag')) {
      style = style.merge(customTextStyleBuilder(const HashtagAttribute(''), context));
    }
    if (attrs.containsKey('mention')) {
      style = style.merge(customTextStyleBuilder(const MentionAttribute(''), context));
    }
    if (attrs.containsKey('cashtag')) {
      style = style.merge(customTextStyleBuilder(const CashtagAttribute(''), context));
    }
    return style;
  }

  /// Builds a GestureRecognizer for links, hashtags, cashtags.
  static GestureRecognizer? _buildRecognizer(
    Map<String, dynamic> attrs,
    BuildContext context,
    String data,
  ) {
    if (attrs.containsKey('a') && attrs['a'] != null) {
      return TapGestureRecognizer()
        ..onTap = () => ion_text_span_builder.TextSpanBuilder.defaultOnTap(
              context,
              match: TextMatch(
                data,
                matcher: const UrlMatcher(),
              ),
            );
    }
    if (attrs.containsKey('hashtag')) {
      return customRecognizerBuilder(
        context,
        HashtagAttribute.withValue(attrs['hashtag'] as String),
      );
    }
    if (attrs.containsKey('cashtag')) {
      return customRecognizerBuilder(
        context,
        CashtagAttribute.withValue(attrs['cashtag'] as String),
      );
    }
    return null;
  }
}
