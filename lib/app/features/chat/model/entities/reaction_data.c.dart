// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'reaction_data.c.freezed.dart';

@Freezed(equal: false)
class ReactionEntity with _$ReactionEntity {
  const factory ReactionEntity({
    required String id,
    required String pubkey,
    required DateTime createdAt,
    required ReactionData data,
  }) = _ReactionEntity;

  const ReactionEntity._();

  factory ReactionEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventId: eventMessage.id, kind: kind);
    }

    return ReactionEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      createdAt: eventMessage.createdAt,
      data: ReactionData.fromEventMessage(eventMessage),
    );
  }

  static const int kind = 7;

  static const String likeSymbol = '+';
}

@freezed
class ReactionData with _$ReactionData {
  const factory ReactionData({
    required String pubkey,
    required String content,
    required String eventId,
  }) = _ReactionData;

  const ReactionData._();

  factory ReactionData.fromEventMessage(EventMessage eventMessage) {
    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);
    final kind = tags['k']?.first[1];
    final eventId = tags['e']?.first[1];
    final pubkey = tags['p']?.first[1];

    if (eventId == null ||
        pubkey == null ||
        kind != ReactionEntity.kind.toString()) {
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
