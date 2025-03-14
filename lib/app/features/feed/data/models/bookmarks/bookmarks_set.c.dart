// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/replaceable_event_identifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';

part 'bookmarks_set.c.freezed.dart';

enum BookmarksSetType {
  posts(dTagName: 'posts'),
  videos(dTagName: 'videos'),
  articles(dTagName: 'articles'),
  chats(dTagName: 'archived_conversations'),
  unknown(dTagName: 'unknown');

  const BookmarksSetType({required this.dTagName});

  final String dTagName;
}

@Freezed(equal: false)
class BookmarksSetEntity
    with IonConnectEntity, CacheableEntity, ReplaceableEntity, _$BookmarksSetEntity {
  const factory BookmarksSetEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required DateTime createdAt,
    required BookmarksSetData data,
  }) = _BookmarksSetEntity;

  const BookmarksSetEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/51.md#sets
  factory BookmarksSetEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventMessage.id, kind: kind);
    }

    return BookmarksSetEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: BookmarksSetData.fromEventMessage(eventMessage),
    );
  }

  static const int kind = 30003;
}

@freezed
class BookmarksSetData with _$BookmarksSetData implements EventSerializable, ReplaceableEntityData {
  const factory BookmarksSetData({
    required BookmarksSetType type,
    required List<ReplaceableEventReference> postsRefs,
    required List<ReplaceableEventReference> articlesRefs,
    @Default('') String content,
    @Default([]) List<String> communitiesIds,
  }) = _BookmarksSetData;

  const BookmarksSetData._();

  factory BookmarksSetData.fromEventMessage(EventMessage eventMessage) {
    final typeName = eventMessage.tags
        .firstWhereOrNull((tag) => tag[0] == ReplaceableEventIdentifier.tagName)?[1];

    if (typeName == null) {
      throw Exception('BookmarksSet event should have `${ReplaceableEventIdentifier.tagName}` tag');
    }

    return BookmarksSetData(
      content: eventMessage.content ?? '',
      postsRefs: eventMessage.tags
          .where((tag) => tag[0] == ReplaceableEventReference.tagName)
          .map(ReplaceableEventReference.fromTag)
          .where((event) => event.kind == ModifiablePostEntity.kind)
          .toList(),
      communitiesIds: eventMessage.tags.where((tag) => tag[0] == 'h').map((tag) => tag[1]).toList(),
      articlesRefs: eventMessage.tags
          .where((tag) => tag[0] == ReplaceableEventReference.tagName)
          .map(ReplaceableEventReference.fromTag)
          .where((event) => event.kind == ArticleEntity.kind)
          .toList(),
      type: BookmarksSetType.values.singleWhereOrNull((set) => set.dTagName == typeName) ??
          BookmarksSetType.unknown,
    );
  }

  @override
  FutureOr<EventMessage> toEventMessage(
    EventSigner signer, {
    DateTime? createdAt,
    String content = '',
    List<List<String>> tags = const [],
  }) {
    return EventMessage.fromData(
      signer: signer,
      content: this.content,
      createdAt: createdAt,
      kind: BookmarksSetEntity.kind,
      tags: [
        ...tags,
        ReplaceableEventIdentifier(value: type.dTagName).toTag(),
        ...postsRefs.map((ref) => ref.toTag()),
        ...articlesRefs.map((ref) => ref.toTag()),
        ...communitiesIds.map((id) => ['h', id]),
        if (type == BookmarksSetType.chats) ['encrypted'],
      ],
    );
  }

  @override
  ReplaceableEventReference toReplaceableEventReference(String pubkey) {
    return ReplaceableEventReference(
      pubkey: pubkey,
      dTag: type.dTagName,
      kind: BookmarksSetEntity.kind,
    );
  }
}
