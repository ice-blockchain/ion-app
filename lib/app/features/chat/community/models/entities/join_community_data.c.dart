import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/ion_connect/model/entity_expiration.c.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/tags/community_identifer_tag.c.dart';
import 'package:ion/app/features/ion_connect/model/tags/pubkey_tag.c.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'join_community_data.c.freezed.dart';

@Freezed(equal: false)
class JoinCommunityEntity with _$JoinCommunityEntity, IonConnectEntity {
  const factory JoinCommunityEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required DateTime createdAt,
    required JoinCommunityData data,
  }) = _JoinCommunityEntity;

  const JoinCommunityEntity._();

  factory JoinCommunityEntity.fromEventMessage(EventMessage eventMessage) {
    return JoinCommunityEntity(
      id: eventMessage.id,
      pubkey: PubkeyTag.fromTags(eventMessage.tags).value,
      masterPubkey: eventMessage.pubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: JoinCommunityData.fromEventMessage(eventMessage),
    );
  }

  // https://github.com/ice-blockchain/subzero/blob/master/.ion-connect-protocol/ICIP-3000.md
  static const kind = 1750;
}

@Freezed(equal: false)
class JoinCommunityData with _$JoinCommunityData implements EventSerializable {
  const factory JoinCommunityData({
    required String uuid,
    required String pubkey,
    String? auth,
  }) = _JoinCommunityData;

  factory JoinCommunityData.fromEventMessage(EventMessage eventMessage) {
    return JoinCommunityData(
      uuid: CommunityIdentifierTag.fromTags(eventMessage.tags).value,
      pubkey: PubkeyTag.fromTags(eventMessage.tags).value,
      auth: eventMessage.tags.firstWhereOrNull((tag) => tag[0] == 'authorization')?.last,
    );
  }

  const JoinCommunityData._();

  @override
  FutureOr<EventMessage> toEventMessage(
    EventSigner eventSigner, {
    DateTime? createdAt,
    List<List<String>> tags = const [],
  }) {
    return EventMessage.fromData(
      signer: eventSigner,
      createdAt: createdAt,
      kind: JoinCommunityEntity.kind,
      tags: [
        ...tags,
        CommunityIdentifierTag(value: uuid).toTag(),
        PubkeyTag(value: pubkey).toTag(),
        if (auth != null) ['authorization', auth!],
        if (auth != null)
          //TODO: ask about expiration
          EntityExpiration(value: DateTime.now().add(const Duration(days: 1))).toTag(),
      ],
      content: '',
    );
  }
}
