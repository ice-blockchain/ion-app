// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/nostr/model/event_serializable.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'article_data.freezed.dart';

@Freezed(equal: false)
class ArticleEntity with _$ArticleEntity, NostrEntity implements CacheableEntity {
  const factory ArticleEntity({
    required String id,
    required String pubkey,
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
      createdAt: eventMessage.createdAt,
      data: ArticleData.fromEventMessage(eventMessage),
    );
  }

  @override
  String get cacheKey => cacheKeyBuilder(id: id);

  static String cacheKeyBuilder({required String id}) => id;

  static const kind = 30023;
}

class ArticleData implements EventSerializable {
  ArticleData({
    required this.content,
    this.title,
    this.image,
    this.summary,
    this.publishedAt,
  });

  factory ArticleData.fromEventMessage(EventMessage eventMessage) {
    String? title;
    String? image;
    String? summary;
    DateTime? publishedAt;

    for (final tag in eventMessage.tags) {
      if (tag.isNotEmpty) {
        switch (tag[0]) {
          case 'title':
            title = tag[1];
          case 'image':
            image = tag[1];
          case 'summary':
            summary = tag[1];
          case 'published_at':
            final timestamp = int.tryParse(tag[1]);
            if (timestamp != null) {
              publishedAt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
            }
        }
      }
    }

    return ArticleData(
      title: title,
      image: image,
      summary: summary,
      content: eventMessage.content,
      publishedAt: publishedAt,
    );
  }

  @override
  EventMessage toEventMessage(EventSigner signer) {
    return EventMessage.fromData(
      signer: signer,
      kind: ArticleEntity.kind,
      tags: [
        if (title != null) ['title', title!],
        if (image != null) ['image', image!],
        if (summary != null) ['summary', summary!],
        if (publishedAt != null)
          ['published_at', (publishedAt!.millisecondsSinceEpoch / 1000).toString()],
      ],
      content: content,
    );
  }

  final String? title;
  final String? image;
  final String? summary;
  final String content;
  final DateTime? publishedAt;
}
