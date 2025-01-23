// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';

part 'reaction_data.c.freezed.dart';

@Freezed(equal: false)
class ReactionEntity with _$ReactionEntity, IonConnectEntity, ImmutableEntity, CacheableEntity {
  const factory ReactionEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required DateTime createdAt,
    required ReactionData data,
  }) = _ReactionEntity;

  const ReactionEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/25.md
  factory ReactionEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventMessage.id, kind: kind);
    }

    return ReactionEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: ReactionData.fromEventMessage(eventMessage),
    );
  }

  @override
  String get cacheKey =>
      cacheKeyBuilder(eventId: data.eventId, pubkey: masterPubkey, content: data.content);

  static String cacheKeyBuilder({
    required String eventId,
    required String pubkey,
    required String content,
  }) =>
      '$kind:$eventId:$pubkey:$content';

  static const int kind = 7;

  static const String likeSymbol = '+';
}

@freezed
class ReactionData with _$ReactionData implements EventSerializable {
  const factory ReactionData({
    required String content,
    required String eventId,
    required String pubkey,
  }) = _ReactionData;

  const ReactionData._();

  factory ReactionData.fromEventMessage(EventMessage eventMessage) {
    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);
    final eventId = tags['e']?.first[1];
    final pubkey = tags['p']?.first[1];

    if (eventId == null || pubkey == null) {
      throw IncorrectEventTagsException(eventId: eventMessage.id);
    }

    return ReactionData(
      eventId: eventId,
      pubkey: pubkey,
      content: eventMessage.content,
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
      kind: ReactionEntity.kind,
      content: content,
      tags: [
        ...tags,
        ['p', pubkey],
        ['e', eventId],
      ],
    );
  }
}
