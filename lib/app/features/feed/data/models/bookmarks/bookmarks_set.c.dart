// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/nostr/model/event_serializable.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/model/replaceable_event_reference.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.c.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'bookmarks_set.c.freezed.dart';

enum BookmarksSetType { posts, stories, videos, articles, unknown }

@Freezed(equal: false)
class BookmarksSetEntity with _$BookmarksSetEntity, NostrEntity implements CacheableEntity {
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
      throw IncorrectEventKindException(eventId: eventMessage.id, kind: kind);
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

  @override
  String get cacheKey => cacheKeyBuilder(pubkey: masterPubkey, type: data.type);

  static String cacheKeyBuilder({required String pubkey, required BookmarksSetType type}) =>
      '$kind:$type:$pubkey';

  static const int kind = 30003;
}

@freezed
class BookmarksSetData with _$BookmarksSetData implements EventSerializable {
  const factory BookmarksSetData({
    required BookmarksSetType type,
    required List<String> ids,
  }) = _BookmarksSetData;

  const BookmarksSetData._();

  factory BookmarksSetData.fromEventMessage(EventMessage eventMessage) {
    final typeName = eventMessage.tags.firstWhereOrNull((tag) => tag[0] == 'd')?[1];

    if (typeName == null) {
      throw Exception('BookmarksSet event should have `d` tag');
    }

    final type = BookmarksSetType.values.asNameMap()[typeName] ?? BookmarksSetType.unknown;
    final idTag = type == BookmarksSetType.articles ? 'a' : 'e';
    return BookmarksSetData(
      type: BookmarksSetType.values.asNameMap()[typeName] ?? BookmarksSetType.unknown,
      ids: eventMessage.tags.where((tag) => tag[0] == idTag).map((tag) => tag[1]).toList(),
    );
  }

  @override
  FutureOr<EventMessage> toEventMessage(
    EventSigner signer, {
    List<List<String>> tags = const [],
    DateTime? createdAt,
  }) {
    final idTag = type == BookmarksSetType.articles ? 'a' : 'e';
    return EventMessage.fromData(
      signer: signer,
      createdAt: createdAt,
      kind: BookmarksSetEntity.kind,
      tags: [
        ...tags,
        ['d', type.toShortString()],
        ...ids.map((id) => [idTag, id]),
      ],
      content: '',
    );
  }

  ReplaceableEventReference toReplaceableEventReference(String pubkey) {
    return ReplaceableEventReference(
      kind: BookmarksSetEntity.kind,
      pubkey: pubkey,
      dTag: type.toShortString(),
    );
  }
}
