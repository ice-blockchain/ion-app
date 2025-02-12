// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/components/text_editor/attributes.dart';
import 'package:ion/app/extensions/extensions.dart';

DefaultStyles textEditorStyles(BuildContext context, {Color? color}) {
  final textColor = color ?? context.theme.appColors.secondaryText;
  return DefaultStyles(
    paragraph: DefaultTextBlockStyle(
      context.theme.appTextThemes.body2.copyWith(
        color: textColor,
      ),
      HorizontalSpacing.zero,
      VerticalSpacing.zero,
      VerticalSpacing.zero,
      null,
    ),
    bold: context.theme.appTextThemes.body2.copyWith(
      fontWeight: FontWeight.bold,
      color: textColor,
    ),
    italic: context.theme.appTextThemes.body2.copyWith(
      fontStyle: FontStyle.italic,
      color: textColor,
    ),
    placeHolder: DefaultTextBlockStyle(
      context.theme.appTextThemes.body2.copyWith(
        color: context.theme.appColors.tertararyText,
      ),
      HorizontalSpacing.zero,
      VerticalSpacing.zero,
      VerticalSpacing.zero,
      null,
    ),
    lists: DefaultListBlockStyle(
      context.theme.appTextThemes.body2.copyWith(
        color: textColor,
        fontSize: context.theme.appTextThemes.body2.fontSize,
      ),
      HorizontalSpacing.zero,
      VerticalSpacing.zero,
      VerticalSpacing.zero,
      null,
      null,
    ),
    quote: DefaultTextBlockStyle(
      context.theme.appTextThemes.body2.copyWith(
        color: context.theme.appColors.primaryText,
        fontStyle: FontStyle.italic,
      ),
      HorizontalSpacing.zero,
      VerticalSpacing.zero,
      VerticalSpacing.zero,
      BoxDecoration(
        border: Border(
          left: BorderSide(
            color: context.theme.appColors.primaryAccent,
            width: 2.0.s,
          ),
        ),
      ),
    ),
  );
}

TextStyle customTextStyleBuilder(Attribute<dynamic> attribute, BuildContext context) {
  if (attribute.key == MentionAttribute.attributeKey ||
      attribute.key == HashtagAttribute.attributeKey ||
      attribute.key == CashtagAttribute.attributeKey) {
    return TextStyle(
      color: context.theme.appColors.primaryAccent,
      decoration: TextDecoration.none,
    );
  } else if (attribute.key == Attribute.link.key) {
    return TextStyle(
      decoration: TextDecoration.underline,
      color: context.theme.appColors.primaryAccent,
    );
  }
  return const TextStyle();
}
