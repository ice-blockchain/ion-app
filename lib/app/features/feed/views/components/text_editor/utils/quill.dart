// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:ion/app/extensions/extensions.dart';

String encodeArticleContent(QuillController controller) {
  return jsonEncode(controller.document.toDelta().toJson());
}

QuillController decodeArticleContent(String encodedContent) {
  final decodedJson = jsonDecode(encodedContent);

  if (decodedJson is List<dynamic>) {
    final delta = Delta.fromJson(decodedJson);
    return QuillController(
      document: Document.fromDelta(delta),
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: true,
    );
  } else {
    throw const FormatException('Invalid content format for Quill Delta');
  }
}

DefaultStyles getCustomStyles(BuildContext context) {
  return DefaultStyles(
    paragraph: DefaultTextBlockStyle(
      context.theme.appTextThemes.body2.copyWith(
        color: context.theme.appColors.secondaryText,
      ),
      HorizontalSpacing.zero,
      VerticalSpacing.zero,
      VerticalSpacing.zero,
      null,
    ),
    bold: context.theme.appTextThemes.body2.copyWith(
      fontWeight: FontWeight.bold,
      color: context.theme.appColors.secondaryText,
    ),
    italic: context.theme.appTextThemes.body2.copyWith(
      fontStyle: FontStyle.italic,
      color: context.theme.appColors.secondaryText,
    ),
    placeHolder: DefaultTextBlockStyle(
      context.theme.appTextThemes.body2.copyWith(
        color: context.theme.appColors.quaternaryText,
      ),
      HorizontalSpacing.zero,
      VerticalSpacing.zero,
      VerticalSpacing.zero,
      null,
    ),
    lists: DefaultListBlockStyle(
      context.theme.appTextThemes.body2.copyWith(
        color: context.theme.appColors.secondaryText,
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
  if (attribute.key == 'mention') {
    return TextStyle(
      color: context.theme.appColors.primaryAccent,
      decoration: TextDecoration.none,
    );
  } else if (attribute.key == 'hashtag') {
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
