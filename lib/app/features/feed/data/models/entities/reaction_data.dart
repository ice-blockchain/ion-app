// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/nostr/model/event_serializable.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'reaction_data.freezed.dart';

@Freezed(equal: false)
class ReactionEntity with _$ReactionEntity, NostrEntity implements CacheableEntity {
  const factory ReactionEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required DateTime createdAt,
    required ReactionData data,
  }) = _ReactionEntity;

  const ReactionEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/25.md
  factory ReactionEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventId: eventMessage.id, kind: kind);
    }

    return ReactionEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: NostrEntity.getMasterPubkey(eventMessage),
      createdAt: eventMessage.createdAt,
      data: ReactionData.fromEventMessage(eventMessage),
    );
  }

  @override
  String get cacheKey =>
      cacheKeyBuilder(eventId: data.eventId, pubkey: pubkey, content: data.content);

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
  EventMessage toEventMessage(EventSigner signer, {List<List<String>> tags = const []}) {
    return EventMessage.fromData(
      signer: signer,
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
