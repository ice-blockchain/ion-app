// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:ion/app/components/text_editor/attributes.dart';
import 'package:ion/app/services/text_parser/model/text_matcher.dart';
import 'package:ion/app/services/text_parser/text_parser.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_quill/markdown_quill.dart';

final _deltaToMd = DeltaToMarkdown();
final _mdToDelta = MarkdownToDelta(markdownDocument: md.Document(encodeHtml: false));

//TODO: process text-editor-single-image, hashtags and other custom attr
String deltaToMarkdown(Delta delta) => _deltaToMd.convert(delta);

//TODO: process text-editor-single-image, hashtags and other custom attr
Delta markdownToDelta(String markdown) => _mdToDelta.convert(markdown);

Delta plainTextToDelta(String text) {
  final matches = TextParser.allMatchers().parse(text.trim());
  final operations = <Operation>[];

  for (final match in matches) {
    operations.add(
      switch (match.matcher) {
        UrlMatcher() => Operation.insert(match.text, {Attribute.link.key: match.text}),
        HashtagMatcher() =>
          Operation.insert(match.text, {HashtagAttribute.attributeKey: match.text}),
        CashtagMatcher() =>
          Operation.insert(match.text, {CashtagAttribute.attributeKey: match.text}),
        _ => Operation.insert(match.text),
      },
    );
  }

  operations.add(Operation.insert('\n'));

  return Delta.fromOperations(operations);
}
