// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:html/dom.dart' as html;
import 'package:html/parser.dart' as html_parser;
import 'package:ion/app/components/text_editor/attributes.dart';
import 'package:ion/app/services/text_parser/model/text_matcher.dart';
import 'package:ion/app/services/text_parser/text_parser.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_quill/markdown_quill.dart';

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
    out.write('\n');
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

Delta _processTextMatchers(Delta inputDelta) {
  final processedDelta = Delta();
  final textParser = TextParser.allMatchers();

  for (final op in inputDelta.toList()) {
    if (op.key == 'insert' && op.data is String) {
      final text = op.data.toString();
      final matches = textParser.parse(text);

      if (matches.isEmpty) {
        processedDelta.insert(text, op.attributes);
      } else {
        for (final match in matches) {
          processedDelta.insert(
            match.text,
            {
              ...?op.attributes,
              ...switch (match.matcher) {
                HashtagMatcher() => {HashtagAttribute.attributeKey: match.text},
                MentionMatcher() => {MentionAttribute.attributeKey: match.text},
                CashtagMatcher() => {CashtagAttribute.attributeKey: match.text},
                UrlMatcher() => {Attribute.link.key: match.text},
                _ => {},
              },
            },
          );
        }
      }
    } else {
      processedDelta.insert(op.data, op.attributes);
    }
  }

  return processedDelta;
}

Delta markdownToDelta(String? markdown) {
  if (markdown == null) {
    return Delta();
  }

  if (markdown.contains('> ')) {
    return _directBlockquoteToDelta(markdown);
  }

  final html = md.markdownToHtml(
    markdown,
    extensionSet: md.ExtensionSet.gitHubFlavored,
  );

  final document = html_parser.parse(html);
  final delta = _convertHtmlToDelta(document.body!);

  return _processTextMatchers(delta);
}

Delta _directBlockquoteToDelta(String markdown) {
  final delta = Delta();
  final lines = markdown.split('\n');

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final trimmedLine = line.trim();

    if (trimmedLine.startsWith('> ')) {
      final content = trimmedLine.substring(2).trim();
      if (content.isNotEmpty) {
        final contentHtml = md.markdownToHtml(
          content,
          extensionSet: md.ExtensionSet.gitHubFlavored,
        );
        final contentDoc = html_parser.parse(contentHtml);
        final contentDelta = _processInlineElement(contentDoc.body!);

        final processedContentDelta = _processTextMatchers(contentDelta);
        for (final op in processedContentDelta.toList()) {
          delta.insert(op.data, op.attributes);
        }

        delta.insert('\n', {'blockquote': true});
      } else {
        delta.insert('\n', {'blockquote': true});
      }
    } else if (trimmedLine.isEmpty) {
      delta.insert('\n');
    } else {
      final partialHtml = md.markdownToHtml(
        line,
        extensionSet: md.ExtensionSet.gitHubFlavored,
      );

      final partialDocument = html_parser.parse(partialHtml);
      final partialDelta = _convertHtmlToDelta(partialDocument.body!);

      final processedPartialDelta = _processTextMatchers(partialDelta);
      for (final op in processedPartialDelta.toList()) {
        delta.insert(op.data, op.attributes);
      }
    }
  }

  return delta;
}

String cleanText(String text) {
  var cleaned = text.replaceAll('\r\n', '\n');
  cleaned = cleaned.replaceAll(RegExp(r'\n{2,}'), ' ');
  cleaned = cleaned.replaceAll('\n', ' ');
  cleaned = cleaned.trim();
  cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');

  return cleaned;
}

Delta _convertHtmlToDelta(html.Element element) {
  final delta = Delta();

  for (final node in element.nodes) {
    if (node is html.Text) {
      final text = cleanText(node.text);
      if (text.isNotEmpty) {
        delta.insert(text);
      }
    } else if (node is html.Element) {
      switch (node.localName) {
        case 'p':
          final innerDelta = _processInlineElement(node);
          for (final op in innerDelta.toList()) {
            delta.insert(op.data, op.attributes);
          }
          delta.insert('\n');
        case 'h1':
          final innerDelta = _processInlineElement(node);
          for (final op in innerDelta.toList()) {
            delta.insert(op.data, op.attributes);
          }
          delta.insert('\n', {'header': 1});
        case 'h2':
          final innerDelta = _processInlineElement(node);
          for (final op in innerDelta.toList()) {
            delta.insert(op.data, op.attributes);
          }
          delta.insert('\n', {'header': 2});
        case 'h3':
          final innerDelta = _processInlineElement(node);
          for (final op in innerDelta.toList()) {
            delta.insert(op.data, op.attributes);
          }
          delta.insert('\n', {'header': 3});
        case 'ul':
          final innerDelta = _processList(node, 'bullet');
          for (final op in innerDelta.toList()) {
            delta.insert(op.data, op.attributes);
          }
        case 'ol':
          final innerDelta = _processList(node, 'ordered');
          for (final op in innerDelta.toList()) {
            delta.insert(op.data, op.attributes);
          }
        case 'blockquote':
          final innerDelta = _processInlineElement(node);
          for (final op in innerDelta.toList()) {
            delta.insert(op.data, op.attributes);
          }
          delta.insert('\n', {'blockquote': true});
        case 'pre':
          final codeElement = node.querySelector('code');
          final content = codeElement?.text ?? node.text;
          if (content.trim().isNotEmpty) {
            delta.insert({
              'text-editor-code': content.trim(),
            });
          }
        case 'img':
          final src = node.attributes['src'] ?? '';
          if (src.isNotEmpty) {
            delta.insert({
              'text-editor-single-image': src,
            });
          }
        case 'hr':
          delta.insert({
            'text-editor-separator': '---',
          });
        default:
          final innerDelta = _convertHtmlToDelta(node);
          for (final op in innerDelta.toList()) {
            delta.insert(op.data, op.attributes);
          }
      }
    }
  }

  return delta;
}

Delta _processInlineElement(html.Element element) {
  final delta = Delta();
  final attributes = <String, dynamic>{};

  switch (element.localName) {
    case 'strong':
    case 'b':
      attributes['bold'] = true;
    case 'em':
    case 'i':
      attributes['italic'] = true;
    case 'u':
      attributes['underline'] = true;
    case 'a':
      attributes['link'] = element.attributes['href'] ?? '';
    case 'code':
      attributes['code'] = true;
    case 'strike':
    case 's':
      attributes['strike'] = true;
  }

  if (element.nodes.isEmpty && element.text.isNotEmpty) {
    final text = cleanText(element.text);
    delta.insert(text, attributes.isNotEmpty ? attributes : null);
    return delta;
  }

  for (final node in element.nodes) {
    if (node is html.Text) {
      final text = cleanText(node.text);
      if (text.isNotEmpty) {
        delta.insert(text, attributes.isNotEmpty ? attributes : null);
      }
    } else if (node is html.Element) {
      final childAttributes = Map<String, dynamic>.from(attributes);

      switch (node.localName) {
        case 'strong':
        case 'b':
          childAttributes['bold'] = true;
        case 'em':
        case 'i':
          childAttributes['italic'] = true;
        case 'u':
          childAttributes['underline'] = true;
        case 'a':
          childAttributes['link'] = node.attributes['href'] ?? '';
        case 'code':
          childAttributes['code'] = true;
        case 'strike':
        case 's':
          childAttributes['strike'] = true;
        case 'img':
          final src = node.attributes['src'] ?? '';
          if (src.isNotEmpty) {
            delta.insert({
              'text-editor-single-image': src,
            });
          }
          continue;
        case 'br':
          delta.insert(' ');
          continue;
        default:
          final innerDelta = _processInlineElement(node);
          for (final op in innerDelta.toList()) {
            if (op.key == 'insert' && op.data is String) {
              delta.insert(op.data, {
                ...childAttributes,
                ...?op.attributes,
              });
            } else {
              delta.insert(op.data, op.attributes);
            }
          }
          continue;
      }

      if (node.text.isNotEmpty) {
        final text = cleanText(node.text);
        delta.insert(text, childAttributes);
      } else {
        final innerDelta = _processInlineElement(node);
        for (final op in innerDelta.toList()) {
          if (op.key == 'insert' && op.data is String) {
            delta.insert(op.data, {
              ...childAttributes,
              ...?op.attributes,
            });
          } else {
            delta.insert(op.data, op.attributes);
          }
        }
      }
    }
  }

  return delta;
}

Delta _processList(html.Element listElement, String listType) {
  final delta = Delta();

  for (final node in listElement.nodes) {
    if (node is html.Element && node.localName == 'li') {
      final isChecklist = node.attributes.containsKey('data-checked');
      final isChecked = node.attributes['data-checked'] == 'true';

      final listStyle = isChecklist ? (isChecked ? 'checked' : 'unchecked') : listType;

      final innerDelta = _processInlineElement(node);
      for (final op in innerDelta.toList()) {
        delta.insert(op.data, op.attributes);
      }
      delta.insert('\n', {'list': listStyle});

      for (final childNode in node.nodes) {
        if (childNode is html.Element &&
            (childNode.localName == 'ul' || childNode.localName == 'ol')) {
          final nestedListType = childNode.localName == 'ul' ? 'bullet' : 'ordered';
          final nestedDelta = _processList(childNode, nestedListType);

          for (final op in nestedDelta.toList()) {
            if (op.key == 'insert' && op.data == '\n' && op.attributes != null) {
              final attrs = Map<String, dynamic>.from(op.attributes!);
              attrs['indent'] = 1;
              delta.insert('\n', attrs);
            } else {
              delta.insert(op.data, op.attributes);
            }
          }
        }
      }
    }
  }

  return delta;
}
