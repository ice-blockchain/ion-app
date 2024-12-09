// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/related_event.c.dart';
import 'package:ion/app/features/feed/data/models/entities/related_pubkey.c.dart';
import 'package:ion/app/features/nostr/model/event_serializable.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'private_direct_message_data.c.freezed.dart';

@Freezed(equal: false)
class PrivateDirectMessageEntity with _$PrivateDirectMessageEntity, NostrEntity {
  const factory PrivateDirectMessageEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required DateTime createdAt,
    required PrivateDirectMessageData data,
  }) = _PrivateDirectMessageEntity;

  const PrivateDirectMessageEntity._();

  factory PrivateDirectMessageEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw Exception('Incorrect event kind ${eventMessage.kind}, expected $kind');
    }

    return PrivateDirectMessageEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: PrivateDirectMessageData.fromEventMessage(eventMessage),
    );
  }

  static const kind = 14;
}

@freezed
class PrivateDirectMessageData
    with _$PrivateDirectMessageData
    implements EventSerializableByPubkey {
  const factory PrivateDirectMessageData({
    required String content,
    required List<RelatedPubkey> relatedPubkeys,
    required List<RelatedEvent> relatedEvents,
  }) = _PrivateDirectMessageData;

  factory PrivateDirectMessageData.fromEventMessage(EventMessage eventMessage) {
    return PrivateDirectMessageData(
      content: eventMessage.content,
      relatedPubkeys: eventMessage.tags.map(RelatedPubkey.fromTag).toList(),
      relatedEvents: eventMessage.tags.map(RelatedEvent.fromTag).toList(),
    );
  }

  @override
  FutureOr<EventMessage> toEventMessage({
    required String pubkey,
    required DateTime createdAt,
    List<List<String>> tags = const [],
  }) {
    final kind14EventId = EventMessage.calculateEventId(
      publicKey: pubkey,
      createdAt: createdAt,
      kind: PrivateDirectMessageEntity.kind,
      tags: [
        ...tags,
        ...relatedPubkeys.map((pubkey) => pubkey.toTag()),
        ...relatedEvents.map((event) => event.toTag()),
      ],
      content: content,
    );

    final kind14Event = EventMessage(
      id: kind14EventId,
      pubkey: pubkey,
      createdAt: createdAt,
      kind: PrivateDirectMessageEntity.kind,
      tags: tags,
      content: content,
      sig: null,
    );
    return kind14Event;
  }
}
