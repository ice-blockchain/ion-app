// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/model/entity_expiration.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/tags/authorization_tag.c.dart';
import 'package:ion/app/features/ion_connect/model/tags/community_identifer_tag.c.dart';
import 'package:ion/app/features/ion_connect/model/tags/pubkey_tag.c.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'community_join_data.c.freezed.dart';

@freezed
class CommunityJoinEntity with _$CommunityJoinEntity, IonConnectEntity {
  const factory CommunityJoinEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required DateTime createdAt,
    required CommunityJoinData data,
  }) = _CommunityJoinEntity;

  const CommunityJoinEntity._();

  factory CommunityJoinEntity.fromEventMessage(EventMessage eventMessage) {
    return CommunityJoinEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: CommunityJoinData.fromEventMessage(eventMessage),
    );
  }

  @override
  EventReference toEventReference() {
    return ReplaceableEventReference(
      pubkey: pubkey,
      kind: kind,
    );
  }

  // https://github.com/ice-blockchain/subzero/blob/master/.ion-connect-protocol/ICIP-3000.md
  static const kind = 1750;
}

@freezed
class CommunityJoinData with _$CommunityJoinData implements EventSerializable {
  const factory CommunityJoinData({
    required String uuid,
    String? pubkey,
    String? auth,
    DateTime? expiration,
  }) = _CommunityJoinData;

  factory CommunityJoinData.fromEventMessage(EventMessage eventMessage) {
    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);

    return CommunityJoinData(
      uuid: tags[CommunityIdentifierTag.tagName]!.map(CommunityIdentifierTag.fromTag).first.value,
      pubkey: tags[PubkeyTag.tagName]?.map(PubkeyTag.fromTag).first.value,
      auth: tags[AuthorizationTag.tagName]?.map(AuthorizationTag.fromTag).firstOrNull?.value,
      expiration: tags[EntityExpiration.tagName]?.map(EntityExpiration.fromTag).firstOrNull?.value,
    );
  }

  const CommunityJoinData._();

  @override
  FutureOr<EventMessage> toEventMessage(
    EventSigner eventSigner, {
    DateTime? createdAt,
    List<List<String>> tags = const [],
  }) {
    return EventMessage.fromData(
      signer: eventSigner,
      createdAt: createdAt,
      kind: CommunityJoinEntity.kind,
      tags: [
        ...tags,
        CommunityIdentifierTag(value: uuid).toTag(),
        if (pubkey != null) PubkeyTag(value: pubkey).toTag(),
        if (auth != null) ['authorization', auth!],
        if (expiration != null) EntityExpiration(value: expiration!).toTag(),
      ],
      content: '',
    );
  }
}
