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

part 'block_list.c.freezed.dart';

@Freezed(equal: false)
class BlockListEntity with _$BlockListEntity, NostrEntity implements CacheableEntity {
  const factory BlockListEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required DateTime createdAt,
    required BlockListData data,
  }) = _BlockListEntity;

  const BlockListEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/51.md#standard-lists
  factory BlockListEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventId: eventMessage.id, kind: kind);
    }

    return BlockListEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: BlockListData.fromEventMessage(eventMessage),
    );
  }

  @override
  String get cacheKey => cacheKeyBuilder(pubkey: masterPubkey);

  static String cacheKeyBuilder({required String pubkey}) => '$kind:$pubkey';

  static const int kind = 10000;
}

@freezed
class BlockListData with _$BlockListData implements EventSerializable {
  const factory BlockListData({
    required List<String> pubkeys,
  }) = _BlockListData;

  const BlockListData._();

  factory BlockListData.fromEventMessage(EventMessage eventMessage) {
    return BlockListData(
      pubkeys: eventMessage.tags.where((tag) => tag[0] == 'p').map((tag) => tag[1]).toList(),
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
      kind: BlockListEntity.kind,
      tags: [
        ...tags,
        ...pubkeys.map((pubkey) => ['p', pubkey]),
      ],
      content: '',
    );
  }
}
