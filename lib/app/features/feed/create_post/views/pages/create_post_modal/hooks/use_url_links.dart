// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/services/text_parser/model/text_matcher.dart';
import 'package:ion/app/services/text_parser/text_parser.dart';
import 'package:ion/app/utils/future.dart';

/// A hook that extracts URLs from a QuillController's text content while considering attached
/// media files.
List<String> useUrlLinks({
  required QuillController textEditorController,
  required List<MediaFile> mediaFiles,
}) {
  final plainText = useListenableSelector(
    textEditorController,
    () => textEditorController.document.toPlainText(),
  );

  final debouncedText = useDebounced<String>(plainText, 300.milliseconds);
  final links = useState<List<String>>([]);

  useEffect(
    () {
      if (debouncedText == null || debouncedText.isEmpty) {
        links.value = [];
        return null;
      }

      final parsed = TextParser.allMatchers().parse(debouncedText.trim());

      final contentWithoutMedia = parsed.where(
        (m) => !mediaFiles.any((f) => f.path == m.text),
      );

      final foundUrls = contentWithoutMedia
          .where((match) => match.matcher is UrlMatcher)
          .map((match) => match.text)
          .toSet()
          .toList();

      links.value = foundUrls;

      return null;
    },
    [debouncedText, mediaFiles],
  );

  return links.value;
}
