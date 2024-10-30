// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/feed/data/models/post/post_metadata.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/services/text_parser/matchers/url_matcher.dart';
import 'package:ion/app/services/text_parser/text_match.dart';
import 'package:ion/app/services/text_parser/text_parser.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'post_data_from_event.dart';

part 'post_data.freezed.dart';

@freezed
class PostEntity with _$PostEntity implements CacheableEntity, NostrEntity {
  const factory PostEntity({
    required String id,
    required String pubkey,
    required DateTime createdAt,
    required PostData data,
  }) = _PostEntity;

  const PostEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/51.md#sets
  factory PostEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw Exception('Incorrect event with kind ${eventMessage.kind}, expected $kind');
    }

    return PostEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      createdAt: eventMessage.createdAt,
      data: PostData.fromEventMessage(eventMessage),
    );
  }

  @override
  String get cacheKey => id;

  @override
  Type get cacheType => PostEntity;

  static const kind = 1;
}

class PostData {
  PostData({
    required this.content,
  });

  factory PostData.fromEventMessage(EventMessage eventMessage) = _PostDataFromEvent;

  PostData.fromRawContent({
    required String rawContent,
  }) : content = TextParser(matchers: [const UrlMatcher()]).parse(rawContent);

  final List<TextMatch> content;

  // Build metadata on demand (lazy)
  late PostMetadata metadata = _buildMetadata();

  PostMetadata _buildMetadata() {
    final media = content.fold<Map<String, MediaAttachment>>(
      {},
      (result, match) {
        if (match.matcherType == UrlMatcher) {
          result[match.text] = MediaAttachment(url: match.text);
        }
        return result;
      },
    );
    return PostMetadata(media: media);
  }

  @override
  String toString() => 'PostData($content, metadata: $metadata)';
}
