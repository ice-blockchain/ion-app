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

part 'bookmarks.c.freezed.dart';

@Freezed(equal: false)
class BookmarksEntity with _$BookmarksEntity, NostrEntity implements CacheableEntity {
  const factory BookmarksEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required DateTime createdAt,
    required BookmarksData data,
  }) = _BookmarksEntity;

  const BookmarksEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/51.md#standard-lists
  factory BookmarksEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventId: eventMessage.id, kind: kind);
    }

    return BookmarksEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: BookmarksData.fromEventMessage(eventMessage),
    );
  }

  @override
  String get cacheKey => cacheKeyBuilder(pubkey: masterPubkey);

  static String cacheKeyBuilder({required String pubkey}) => '$kind:$pubkey';

  static const int kind = 10003;
}

@freezed
class BookmarksData with _$BookmarksData implements EventSerializable {
  const factory BookmarksData({
    required List<String> ids,
    required List<ReplaceableEventReference> bookmarksSetRefs,
  }) = _BookmarksData;

  const BookmarksData._();

  factory BookmarksData.fromEventMessage(EventMessage eventMessage) {
    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);
    return BookmarksData(
      bookmarksSetRefs: tags[ReplaceableEventReference.tagName]
              ?.map(ReplaceableEventReference.fromTag)
              .toList() ??
          [],
      ids: eventMessage.tags.where((tag) => tag[0] == 'e').map((tag) => tag[1]).toList(),
    );
  }

  @override
  FutureOr<EventMessage> toEventMessage(
    EventSigner signer, {
    List<List<String>> tags = const [],
    DateTime? createdAt,
  }) {
    return EventMessage.fromData(
      signer: signer,
      createdAt: createdAt,
      kind: BookmarksEntity.kind,
      tags: [
        ...tags,
        ...bookmarksSetRefs.map((ref) => ref.toTag()),
        ...ids.map((id) => ['e', id]),
      ],
      content: '',
    );
  }
}