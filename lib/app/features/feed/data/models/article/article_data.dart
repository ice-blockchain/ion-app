// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'article_data.freezed.dart';

@freezed
class ArticleEntity with _$ArticleEntity implements CacheableEntity, NostrEntity {
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
  String get cacheKey => id;

  @override
  Type get cacheType => ArticleEntity;

  static const kind = 30023;
}

class ArticleData {
  ArticleData({
    required this.title,
    required this.image,
    required this.summary,
    required this.content,
    required this.publishedAt,
  });

  factory ArticleData.fromEventMessage(EventMessage eventMessage) {
    return _ArticleDataFromEvent(eventMessage);
  }

  final String title;
  final String image;
  final String summary;
  final String content;
  final DateTime publishedAt;

  @override
  String toString() =>
      'ArticleData(title: $title, image: $image, summary: $summary, publishedAt: $publishedAt)';
}

class _ArticleDataFromEvent extends ArticleData {
  _ArticleDataFromEvent(EventMessage eventMessage)
      : super(
          title: _extractTag(eventMessage, 'title') ?? 'Untitled',
          image: _extractTag(eventMessage, 'image') ?? '',
          summary: _extractTag(eventMessage, 'summary') ?? '',
          content: eventMessage.content,
          publishedAt: _extractPublishedAt(eventMessage),
        );

  static String? _extractTag(EventMessage eventMessage, String tagName) {
    return eventMessage.tags
        .firstWhere((tag) => tag.isNotEmpty && tag[0] == tagName, orElse: () => [])
        .elementAt(1);
  }

  static DateTime _extractPublishedAt(EventMessage eventMessage) {
    final publishedAtTag = eventMessage.tags.firstWhere(
      (tag) => tag.isNotEmpty && tag[0] == 'published_at',
      orElse: () => [],
    );
    if (publishedAtTag.length > 1) {
      final timestamp = int.tryParse(publishedAtTag[1]) ?? DateTime.now().millisecondsSinceEpoch;
      return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    } else {
      return eventMessage.createdAt;
    }
  }
}
