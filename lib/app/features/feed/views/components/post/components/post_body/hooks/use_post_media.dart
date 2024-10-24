// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/core/model/media_metadata.dart';
import 'package:ion/app/features/feed/data/models/post/post_data.dart';
import 'package:ion/app/services/text_parser/matchers/url_matcher.dart';

List<MediaMetadata> usePostMedia(
  PostData postData,
) {
  return postData.content.fold<List<MediaMetadata>>(
    [],
    (result, match) {
      if (match.matcherType == UrlMatcher && postData.metadata.media.containsKey(match.text)) {
        result.add(postData.metadata.media[match.text]!);
      }
      return result;
    },
  );
}
