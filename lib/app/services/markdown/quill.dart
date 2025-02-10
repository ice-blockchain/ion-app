// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_quill/quill_delta.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';
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
  },
);

final _deltaToMd = DeltaToMarkdown(
  customEmbedHandlers: {
    'text-editor-single-image': (embed, out) {
      final imageUrl = embed.value.data;
      out.write('![image]($imageUrl)');
    },
  },
);

String deltaToMarkdown(Delta delta) {
  final processedDelta = Delta();
  for (final op in delta.toList()) {
    if (op.key == 'insert' && (op.attributes?.containsKey('text-editor-single-image') ?? false)) {
      processedDelta.insert({
        'text-editor-single-image': op.attributes!['text-editor-single-image'],
      });
    } else {
      processedDelta.insert(op.data, op.attributes);
    }
  }

  return _deltaToMd.convert(processedDelta);
}

Delta markdownToDelta(String markdown) {
  final delta = _mdToDelta.convert(markdown);

  final processedDelta = Delta();
  for (final op in delta.toList()) {
    if (op.key == 'insert' && op.data is Map) {
      final data = op.data! as Map;
      if (data.containsKey('image')) {
        final imageUrl = data['image'] as String;
        processedDelta.insert({
          'text-editor-single-image': imageUrl,
        });
      } else {
        processedDelta.insert(op.data, op.attributes);
      }
    } else {
      processedDelta.insert(op.data, op.attributes);
    }
  }

  return processedDelta;
}
