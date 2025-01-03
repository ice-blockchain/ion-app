// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/nostr/model/event_serializable.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.c.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'repost_data.c.freezed.dart';

@Freezed(equal: false)
class RepostEntity with _$RepostEntity, NostrEntity implements CacheableEntity {
  const factory RepostEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required DateTime createdAt,
    required RepostData data,
  }) = _RepostEntity;

  const RepostEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/18.md
  factory RepostEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventId: eventMessage.id, kind: kind);
    }

    return RepostEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: RepostData.fromEventMessage(eventMessage),
    );
  }

  @override
  String get cacheKey => cacheKeyBuilder(id: id);

  static String cacheKeyBuilder({required String id}) => id;

  static const int kind = 6;
}

@freezed
class RepostData with _$RepostData implements EventSerializable {
  const factory RepostData({
    required String eventId,
    required String pubkey,
    required EventMessage? repostedEvent,
  }) = _RepostData;

  const RepostData._();

  factory RepostData.fromEventMessage(EventMessage eventMessage) {
    String? eventId;
    String? pubkey;

    for (final tag in eventMessage.tags) {
      if (tag.isNotEmpty) {
        switch (tag[0]) {
          case 'e':
            eventId = tag[1];
          case 'p':
            pubkey = tag[1];
        }
      }
    }

    if (eventId == null || pubkey == null) {
      throw IncorrectEventTagsException(eventId: eventMessage.id);
    }

    return RepostData(
      eventId: eventId,
      pubkey: pubkey,
      repostedEvent: null,
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
      kind: RepostEntity.kind,
      content: repostedEvent != null ? jsonEncode(repostedEvent!.toJson().last) : '',
      tags: [
        ...tags,
        ['p', pubkey],
        ['e', eventId],
      ],
    );
  }
}
