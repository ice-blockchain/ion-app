// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/event_message.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/master_pubkey_tag.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/pubkey_tag.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';

part 'blocked_user_entity.c.freezed.dart';

@freezed
class BlockedUserEntity with IonConnectEntity, ImmutableEntity, _$BlockedUserEntity {
  const factory BlockedUserEntity({
    required String id,
    required String pubkey,
    required DateTime createdAt,
    required String masterPubkey,
    required BlockedUserEntityData data,
  }) = _BlockedUserEntity;

  const BlockedUserEntity._();

  factory BlockedUserEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventMessage.id, kind: kind);
    }

    return BlockedUserEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      createdAt: eventMessage.createdAt,
      masterPubkey: eventMessage.masterPubkey,
      data: BlockedUserEntityData.fromEventMessage(eventMessage),
    );
  }

  @override
  FutureOr<EventMessage> toEventMessage(EventSerializable data) {
    return data.toEventMessage(
      createdAt: createdAt,
      NoPrivateSigner(pubkey),
    );
  }

  static const int kind = 1757;

  @override
  String get signature => '';
}

@freezed
class BlockedUserEntityData with _$BlockedUserEntityData implements EventSerializable {
  const factory BlockedUserEntityData({
    required String content,
    required String sharedId,
    required String masterPubkey,
    required List<String> blockedMasterPubkeys,
  }) = _BlockedUserEntityData;

  const BlockedUserEntityData._();

  factory BlockedUserEntityData.fromEventMessage(EventMessage eventMessage) {
    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);

    final sharedId = tags['d']?.first[1];

    if (sharedId == null) {
      throw ShareableIdentifierDecodeException(eventMessage.id);
    }
    final blockedMasterPubkeys = tags[PubkeyTag.tagName]?.map((tag) => tag[1]).toList() ?? [];

    return BlockedUserEntityData(
      sharedId: tags['d']?.first[1] ?? '',
      content: eventMessage.content,
      masterPubkey: eventMessage.masterPubkey,
      blockedMasterPubkeys: blockedMasterPubkeys,
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
      content: content,
      kind: BlockedUserEntity.kind,
      tags: [
        ...tags,
        ['d', sharedId],
        MasterPubkeyTag(value: masterPubkey).toTag(),
        ...blockedMasterPubkeys.map((pubkey) => PubkeyTag(value: pubkey).toTag()),
      ],
      createdAt: createdAt,
    );
  }
}
