// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:ion/app/features/ion_connect/model/entity_data_with_media_content.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/services/markdown/quill.dart';

/// Returns [content] in Delta format with excluded media links
/// and List of media attachments, extracted from the content.
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
  String? richTextContent,
}) {
  final EntityDataWithMediaContent(:content, :media) = data;
  final markdownContentDelta = markdownToDelta(content);
  final plainTextContentDelta = plainTextToDelta(content);

  final contentDelta =
      markdownContentDelta.length == 1 && markdownContentDelta.operations.first.attributes == null
          ? plainTextContentDelta
          : markdownContentDelta;

  return _parseMediaContentDelta(delta: contentDelta, media: media);
}

/// Parses the provided [delta] content to extract media links and separate them from non-media content.
///
/// Parameters:
/// - [delta]: The [Delta] object representing the content to be parsed.
/// - [media]: A map of all available media links.
///
/// Returns:
/// - [content]: A new [Delta] object with non-media operations.
/// - [media]: A list of [MediaAttachment] objects extracted from the content.
({Delta content, List<MediaAttachment> media}) _parseMediaContentDelta({
  required Delta delta,
  required Map<String, MediaAttachment> media,
}) {
  if (media.isEmpty) return (content: delta, media: []);

  final mediaFromContent = <MediaAttachment>[];
  final nonMediaOperations = <Operation>[];

  var afterMedia = false;
  for (final operation in delta.operations) {
    final attributes = operation.attributes;
    if (attributes != null &&
        attributes.containsKey(Attribute.link.key) &&
        media.containsKey(attributes[Attribute.link.key])) {
      afterMedia = true;
      mediaFromContent.add(media[attributes[Attribute.link.key]]!);
    } else {
      // [afterMedia] and [trimmedValue] are needed to handle the case with
      // processing Delta, that is built upon a plain text -
      // there we insert media links as plain text in the beginning of the content,
      // dividing those with a whitespace.
      // After the links are extracted, we need to remove the whitespaces as well.
      final value = operation.value as String;
      final trimmedValue =
          afterMedia && value.startsWith(' ') ? value.replaceFirst(' ', '') : value;
      afterMedia = false;

      if (trimmedValue.isNotEmpty) {
        // Preserve original attributes for non-media content
        nonMediaOperations.add(
          operation.attributes != null
              ? Operation.insert(trimmedValue, operation.attributes)
              : Operation.insert(trimmedValue),
        );
      }
    }
  }

  return (content: Delta.fromOperations(nonMediaOperations), media: mediaFromContent);
}

Delta? useRichTextContentToDelta({
  required String? deltaContent,
}) {
  return useMemoized(
    () {
      try {
        if (deltaContent == null) return null;
        final delta = Delta.fromJson(jsonDecode(deltaContent) as List<dynamic>);
        return convertTextWithImageAttributesToEmbeds(delta);
      } catch (e) {
        return null;
      }
    },
    [deltaContent],
  );
}
