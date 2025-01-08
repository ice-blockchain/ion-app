// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'generic_repost.c.freezed.dart';

@Freezed(equal: false)
class GenericRepostEntity with _$GenericRepostEntity, IonConnectEntity implements CacheableEntity {
  const factory GenericRepostEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
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
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: GenericRepostData.fromEventMessage(eventMessage),
    );
  }

  @override
  String get cacheKey => cacheKeyBuilder(id: id);

  static String cacheKeyBuilder({required String id}) => id;

  static const int kind = 16;
}

@freezed
class GenericRepostData with _$GenericRepostData implements EventSerializable {
  const factory GenericRepostData({
    required String eventId,
    required String pubkey,
    required EventMessage? repostedEvent,
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
      kind: GenericRepostEntity.kind,
      content: repostedEvent != null ? jsonEncode(repostedEvent!.toJson().last) : '',
      tags: [
        ...tags,
        ['p', pubkey],
        ['e', eventId],
        ['k', kind.toString()],
      ],
    );
  }
}
