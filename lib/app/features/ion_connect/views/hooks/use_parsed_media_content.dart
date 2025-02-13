// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:ion/app/features/ion_connect/model/entity_data_with_media_content.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/services/markdown/quill.dart';
import 'package:ion/app/services/text_parser/model/text_match.c.dart';
import 'package:ion/app/services/text_parser/model/text_matcher.dart';
import 'package:ion/app/services/text_parser/text_parser.dart';

({Delta content, List<MediaAttachment> media}) useParsedMediaContent({
  required EntityDataWithMediaContent data,
}) {
  return useMemoized(
    () => parseMediaContent(data: data),
    [data],
  );
}

({Delta content, List<MediaAttachment> media}) parseMediaContent({
  required EntityDataWithMediaContent data,
}) {
  final EntityDataWithMediaContent(:content, :media) = data;
  final markdownContent = markdownToDelta(content);
  final matchesContent = TextParser.allMatchers().parse(content.trim());

  if (markdownContent.operations.length == 1 &&
      markdownContent.operations.first.attributes == null &&
      (matchesContent.length > 1 || matchesContent.firstOrNull?.matcher is UrlMatcher)) {
    // Handle old "plain text" content format
    return _parsePlainTextContent(matches: matchesContent, media: media);
  }

  return _parseMarkdownsContent(markdownContent: markdownContent, media: media);
}

({Delta content, List<MediaAttachment> media}) _parseMarkdownsContent({
  required Delta markdownContent,
  required Map<String, MediaAttachment> media,
}) {
  if (media.isEmpty) return (content: markdownContent, media: []);

  final mediaFromContent = <MediaAttachment>[];
  final nonMediaOperations = <Operation>[];

  for (final operation in markdownContent.operations) {
    final attributes = operation.attributes;
    if (attributes != null &&
        attributes.containsKey(Attribute.link.key) &&
        media.containsKey(attributes[Attribute.link.key])) {
      mediaFromContent.add(media[attributes[Attribute.link.key]]!);
    } else {
      nonMediaOperations.add(operation);
    }
  }

  return (content: Delta.fromOperations(nonMediaOperations), media: mediaFromContent);
}

({Delta content, List<MediaAttachment> media}) _parsePlainTextContent({
  required List<TextMatch> matches,
  required Map<String, MediaAttachment> media,
}) {
  final mediaFromContent = <MediaAttachment>[];
  final nonMediaOperations = <Operation>[];

  for (final match in matches) {
    if (match.matcher is UrlMatcher) {
      if (media.containsKey(match.text)) {
        mediaFromContent.add(media[match.text]!);
      } else {
        nonMediaOperations.add(Operation.insert(match.text, {Attribute.link.key: match.text}));
      }
    } else {
      nonMediaOperations.add(Operation.insert(match.text));
    }
  }

  nonMediaOperations.add(Operation.insert('\n'));

  return (content: Delta.fromOperations(nonMediaOperations), media: mediaFromContent);
}
