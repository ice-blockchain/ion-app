// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/nostr/model/event_serializable.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/model/related_hashtag.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:uuid/uuid.dart';

part 'article_data.c.freezed.dart';

@Freezed(equal: false)
class ArticleEntity with _$ArticleEntity, NostrEntity implements CacheableEntity {
  const factory ArticleEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required DateTime createdAt,
    required ArticleData data,
  }) = _ArticleEntity;

  const ArticleEntity._();

  factory ArticleEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw Exception('Incorrect event kind ${eventMessage.kind}, expected $kind');
    }

    return ArticleEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: ArticleData.fromEventMessage(eventMessage),
    );
  }

  @override
  String get cacheKey => cacheKeyBuilder(id: id);

  static String cacheKeyBuilder({required String id}) => id;

  static const kind = 30023;
}

@freezed
class ArticleData with _$ArticleData implements EventSerializable {
  const factory ArticleData({
    required String content,
    required Map<String, MediaAttachment> media,
    String? title,
    String? image,
    String? summary,
    DateTime? publishedAt,
    List<RelatedHashtag>? relatedHashtags,
  }) = _ArticleData;

  const ArticleData._();

  factory ArticleData.fromEventMessage(EventMessage eventMessage) {
    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);

    final title = tags['title']?.firstOrNull?[1];
    final image = tags['image']?.firstOrNull?[1];
    final summary = tags['summary']?.firstOrNull?[1];
    DateTime? publishedAt;

    if (tags['published_at']?.firstOrNull?[1] != null) {
      final timestamp = int.tryParse(tags['published_at']!.first[1]);
      if (timestamp != null) {
        publishedAt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      }
    }

    final mediaAttachments = _buildMedia(tags[MediaAttachment.tagName]);

    return ArticleData(
      content: eventMessage.content,
      media: mediaAttachments,
      title: title,
      image: image,
      summary: summary,
      publishedAt: publishedAt,
      relatedHashtags: tags[RelatedHashtag.tagName]?.map(RelatedHashtag.fromTag).toList(),
    );
  }

  factory ArticleData.fromRawContent(String content) {
    final hashtags = extractHashtagsFromMarkdown(content);

    return ArticleData(
      content: content,
      relatedHashtags: hashtags,
      media: {},
    );
  }

  @override
  FutureOr<EventMessage> toEventMessage(
    EventSigner signer, {
    List<List<String>> tags = const [],
    DateTime? createdAt,
  }) {
    final uniqueIdForEditing = const Uuid().v4(); // Required to be set in 'd' tag

    return EventMessage.fromData(
      signer: signer,
      createdAt: createdAt,
      kind: ArticleEntity.kind,
      tags: [
        ...tags,
        if (title != null) ['title', title!],
        if (image != null) ['image', image!],
        if (summary != null) ['summary', summary!],
        if (publishedAt != null)
          ['published_at', (publishedAt!.millisecondsSinceEpoch / 1000).toString()],
        if (media.isNotEmpty) ...media.values.map((mediaAttachment) => mediaAttachment.toTag()),
        [
          'd',
          uniqueIdForEditing,
        ],
      ],
      content: content,
    );
  }

  static List<RelatedHashtag> extractHashtagsFromMarkdown(String content) {
    final operations = jsonDecode(content) as List<dynamic>;
    return operations
        .whereType<Map<String, dynamic>>()
        .where(
          (operation) =>
              operation.containsKey('insert') &&
              operation['insert'] is String &&
              (operation['insert'] as String).startsWith('#'),
        )
        .map((operation) {
      final insert = operation['insert']! as String;
      return RelatedHashtag(value: insert);
    }).toList();
  }

  static Map<String, MediaAttachment> _buildMedia(List<List<String>>? mediaTags) {
    if (mediaTags == null) return {};
    return {
      for (final tag in mediaTags)
        if (tag.length > 1) tag[1]: MediaAttachment.fromTag(tag),
    };
  }

  @override
  String toString() {
    return 'ArticleData(content: $content, media: $media, title: $title, image: $image, summary: $summary, publishedAt: $publishedAt)';
  }
}
