// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/core/model/media_type.dart';
import 'package:ice/app/features/feed/data/models/post/post_media_data.dart';
import 'package:ice/app/features/feed/data/models/post/post_metadata.dart';
import 'package:ice/app/services/text_parser/matchers/url_matcher.dart';
import 'package:ice/app/services/text_parser/text_match.dart';
import 'package:ice/app/services/text_parser/text_parser.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'post_data_from_event.dart';

class PostData {
  PostData({
    required this.id,
    required this.content,
  });

  PostData.fromRawContent({
    required this.id,
    required String rawContent,
  }) : content = TextParser(matchers: [const UrlMatcher()]).parse(rawContent);

  factory PostData.fromEventMessage(EventMessage eventMessage) = _PostDataFromEvent;

  final String id;

  final List<TextMatch> content;

  // Build metadata on demand (lazy)
  late PostMetadata metadata = _buildMetadata();

  PostMetadata _buildMetadata() {
    final media = content.fold<Map<String, PostMediaData>>(
      {},
      (result, match) {
        if (match.matcherType == UrlMatcher) {
          final mediaType = MediaType.fromUrl(match.text);
          if (mediaType != MediaType.unknown) {
            result[match.text] = PostMediaData(url: match.text, mediaType: mediaType);
          }
        }
        return result;
      },
    );
    return PostMetadata(media: media);
  }

  @override
  String toString() => 'PostData(id: $id, content: $content, metadata: $metadata)';
}
