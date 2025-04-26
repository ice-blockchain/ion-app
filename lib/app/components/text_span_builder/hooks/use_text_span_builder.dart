// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/text_span_builder/text_span_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/services/text_parser/model/text_matcher.dart';

TextSpanBuilder useTextSpanBuilder(
  BuildContext context, {
  TextStyle? defaultStyle,
  Map<TextMatcher, TextStyle>? matcherStyles,
}) {
  final textSpanBuilder = useMemoized(
    () => TextSpanBuilder(
      defaultStyle: defaultStyle ??
          context.theme.appTextThemes.body2.copyWith(
            color: context.theme.appColors.primaryText,
          ),
      matcherStyles: matcherStyles ?? TextSpanBuilder.defaultMatchersStyles(context),
    ),
  );

  useEffect(
    () => textSpanBuilder.dispose,
    [textSpanBuilder],
  );

  return textSpanBuilder;
}
