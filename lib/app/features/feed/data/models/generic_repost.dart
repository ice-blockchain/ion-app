// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/nostr/model/event_serializable.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'generic_repost.freezed.dart';

@Freezed(equal: false)
class GenericRepostEntity with _$GenericRepostEntity, NostrEntity implements CacheableEntity {
  const factory GenericRepostEntity({
    required String id,
    required String pubkey,
    required DateTime createdAt,
    required GenericRepostData data,
  }) = _GenericRepostEntity;

  const GenericRepostEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/18.md#generic-reposts
  factory GenericRepostEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventId: eventMessage.id, kind: kind);
    }

    return GenericRepostEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      createdAt: eventMessage.createdAt,
      data: GenericRepostData.fromEventMessage(eventMessage),
    );
  }

  @override
  String get cacheKey => id;

  @override
  Type get cacheType => GenericRepostEntity;

  static const int kind = 16;
}

@freezed
class GenericRepostData with _$GenericRepostData implements EventSerializable {
  const factory GenericRepostData({
    required String eventId,
    required String pubkey,
    required int kind,
  }) = _GenericRepostData;

  const GenericRepostData._();

  factory GenericRepostData.fromEventMessage(EventMessage eventMessage) {
    String? eventId;
    String? pubkey;
    int? kind;

    for (final tag in eventMessage.tags) {
      if (tag.isNotEmpty) {
        switch (tag[0]) {
          case 'e':
            eventId = tag[1];
          case 'p':
            pubkey = tag[1];
          case 'k':
            kind = int.tryParse(tag[1]);
        }
      }
    }

    if (eventId == null || pubkey == null || kind == null) {
      throw IncorrectEventTagsException(eventId: eventMessage.id);
    }

    return GenericRepostData(
      eventId: eventId,
      pubkey: pubkey,
      kind: kind,
    );
  }

  @override
  EventMessage toEventMessage(EventSigner signer) {
    return EventMessage.fromData(
      signer: signer,
      kind: GenericRepostEntity.kind,
      content: '',
      tags: [
        ['p', pubkey],
        ['e', eventId],
        ['k', kind.toString()],
      ],
    );
  }
}