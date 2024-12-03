// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/text_span_builder/text_span_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
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

    return TextSpanBuilder(
      defaultStyle: style,
      matcherStyles: TextSpanBuilder.defaultMatchersStyles(
        context,
        style: style?.copyWith(color: context.theme.appColors.darkBlue),
      ),
    ).build(
      TextParser.allMatchers().parse(text),
    );
  }
}
