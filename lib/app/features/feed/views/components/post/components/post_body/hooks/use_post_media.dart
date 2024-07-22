import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:ice/app/features/feed/model/post/post_media_data.dart';
import 'package:ice/app/services/text_parser/matchers/url_matcher.dart';

List<PostMediaData> usePostMedia(
  PostData postData,
) {
  return postData.content.fold<List<PostMediaData>>(
    [],
    (result, match) {
      if (match.matcherType == UrlMatcher && postData.metadata.media.containsKey(match.text)) {
        result.add(postData.metadata.media[match.text]!);
      }
      return result;
    },
  );
}
