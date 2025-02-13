// SPDX-License-Identifier: ice License 1.0

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
}) {
  final EntityDataWithMediaContent(:content, :media) = data;
  final markdownContent = markdownToDelta(content);
  final plainTextContent = plainTextToDelta(content);

  final deltaContent =
      markdownContent.length == 1 && markdownContent.operations.first.attributes == null
          ? plainTextContent
          : markdownContent;

  return _parseDeltaMediaContent(delta: deltaContent, media: media);
}

({Delta content, List<MediaAttachment> media}) _parseDeltaMediaContent({
  required Delta delta,
  required Map<String, MediaAttachment> media,
}) {
  if (media.isEmpty) return (content: delta, media: []);

  final mediaFromContent = <MediaAttachment>[];
  final nonMediaOperations = <Operation>[];

  for (final operation in delta.operations) {
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
