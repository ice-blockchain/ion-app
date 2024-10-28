// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/post/post_data.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/services/text_parser/matchers/url_matcher.dart';

List<MediaAttachment> usePostMedia(
  PostData postData,
) {
  return postData.content.fold<List<MediaAttachment>>(
    [],
    (result, match) {
      if (match.matcherType == UrlMatcher && postData.metadata.media.containsKey(match.text)) {
        result.add(postData.metadata.media[match.text]!);
      }
      return result;
    },
  );
}
