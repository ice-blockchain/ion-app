// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/entities/post_data.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/services/text_parser/text_matcher.dart';

List<MediaAttachment> usePostMedia(
  PostData postData,
) {
  return postData.content.fold<List<MediaAttachment>>(
    [],
    (result, match) {
      if (match.matcher is UrlMatcher && postData.media.containsKey(match.text)) {
        result.add(postData.media[match.text]!);
      }
      return result;
    },
  );
}
