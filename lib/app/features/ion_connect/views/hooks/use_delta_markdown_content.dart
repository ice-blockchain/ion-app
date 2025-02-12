// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:ion/app/features/ion_connect/model/entity_data_with_media_content.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/services/markdown/quill.dart';

({Delta content, List<MediaAttachment> media}) useParsedMarkdownContent({
  required EntityDataWithMediaContent data,
}) {
  return useMemoized(
    () => parseMarkdownContent(data: data),
    [data],
  );
}

({Delta content, List<MediaAttachment> media}) parseMarkdownContent({
  required EntityDataWithMediaContent data,
}) {
  final EntityDataWithMediaContent(:content, :media) = data;
  final parsedContent = markdownToDelta(content);

  if (media.isEmpty) return (content: parsedContent, media: []);

  final mediaFromContent = <MediaAttachment>[];
  final nonMediaOperations = <Operation>[];

  for (final operation in parsedContent.operations) {
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
