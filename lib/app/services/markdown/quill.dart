// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:ion/app/components/text_editor/attributes.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_code_block/text_editor_code_block.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';
import 'package:ion/app/services/text_parser/model/text_matcher.dart';
import 'package:ion/app/services/text_parser/text_parser.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_quill/markdown_quill.dart';

final _mdDocument = md.Document(
  encodeHtml: false,
  extensionSet: md.ExtensionSet.gitHubFlavored,
);

final _mdToDelta = MarkdownToDelta(
  markdownDocument: _mdDocument,
  customElementToEmbeddable: {
    'img': (attrs) {
      final imageUrl = attrs['src'] ?? '';
      return TextEditorSingleImageEmbed(imageUrl);
    },
    'pre': (attrs) {
      final content = attrs['content'] ?? '';
      return TextEditorCodeEmbed(content: content);
    },
  },
);

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

  if (operations.isNotEmpty && !(operations.last.data! as String).endsWith('\n')) {
    operations.add(Operation.insert('\n'));
  }

  return Delta.fromOperations(operations);
}

final deltaToMd = DeltaToMarkdown(
  customEmbedHandlers: {
    'text-editor-single-image': (embed, out) {
      final imageUrl = embed.value.data;
      out.write('![image]($imageUrl)');
    },
    'text-editor-separator': (embed, out) {
      out.write('\n---\n');
    },
    'text-editor-code': (embed, out) {
      final content = embed.value.data;
      out.write('\n```\n$content\n```\n');
    },
  },
  visitLineHandleNewLine: (style, out) {
    if (!out.toString().endsWith('\n\n')) {
      out.write('\n\n');
    }
  },
);

String deltaToMarkdown(Delta delta) {
  final processedDelta = Delta();
  for (final op in delta.toList()) {
    if (op.key == 'insert') {
      if (op.data is Map) {
        processedDelta.insert(op.data);
      } else if (op.attributes?.containsKey('text-editor-single-image') ?? false) {
        processedDelta.insert({
          'text-editor-single-image': op.attributes!['text-editor-single-image'],
        });
      } else {
        processedDelta.insert(op.data, op.attributes);
      }
    }
  }
  return deltaToMd.convert(processedDelta);
}

Delta markdownToDelta(String markdown) {
  final processedMarkdown = markdown.trimRight().replaceAllMapped(
        RegExp(r'(\n\s*\n)'),
        (match) => '\n\u0000\n',
      );

  final delta = _mdToDelta.convert(processedMarkdown);
  final processedDelta = Delta();

  for (final op in delta.toList()) {
    if (op.key == 'insert' && op.data is Map) {
      final data = op.data! as Map;
      if (data.containsKey('image')) {
        processedDelta.insert({
          'text-editor-single-image': data['image'],
        });
      } else if (data.containsKey('divider')) {
        processedDelta.insert({
          'text-editor-separator': '---',
        });
      } else {
        processedDelta.insert(op.data, op.attributes);
      }
    } else {
      final text = op.data is String ? op.data! as String : op.data.toString();

      if (text.contains('\u0000') && op.data is String) {
        var replacement = '\n\n';
        final opsList = processedDelta.toList();
        if (opsList.isNotEmpty &&
            opsList.last.data is String &&
            (opsList.last.data! as String).endsWith('\n')) {
          replacement = '\n';
        }

        final newText = text.replaceAll('\u0000', replacement).replaceAll(RegExp(r'\n +'), '\n');
        processedDelta.insert(newText, op.attributes);
      } else {
        processedDelta.insert(text, op.attributes);
      }
    }
  }

  return processedDelta;
}
