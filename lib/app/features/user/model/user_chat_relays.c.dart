// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/user/model/user_relays.c.dart';

part 'user_chat_relays.c.freezed.dart';

@Freezed(equal: false)
class UserChatRelaysEntity
    with IonConnectEntity, CacheableEntity, ReplaceableEntity, _$UserChatRelaysEntity {
  const factory UserChatRelaysEntity({
    required String id,
    required String pubkey,
    required String signature,
    required String masterPubkey,
    required DateTime createdAt,
    required UserChatRelaysData data,
  }) = _UserChatRelaysEntity;

  const UserChatRelaysEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/17.md#publishing
  factory UserChatRelaysEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventMessage.id, kind: kind);
    }

    return UserChatRelaysEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: UserChatRelaysData.fromEventMessage(eventMessage),
    );
  }

  List<String> get urls => data.list.map((relay) => relay.url).toList();

  static const int kind = 10050;
}

@freezed
class UserChatRelaysData
    with _$UserChatRelaysData
    implements EventSerializable, ReplaceableEntityData {
  const factory UserChatRelaysData({
    required List<UserRelay> list,
  }) = _UserChatRelaysData;

  const UserChatRelaysData._();

  factory UserChatRelaysData.fromEventMessage(EventMessage eventMessage) {
    return UserChatRelaysData(
      list: [
        for (final tag in eventMessage.tags)
          if (tag[0] == 'relay') fromRelayTag(tag),
      ],
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
      kind: UserChatRelaysEntity.kind,
      tags: [
        ...tags,
        ...list.map(toRelayTag),
      ],
      content: '',
    );
  }

  @override
  ReplaceableEventReference toReplaceableEventReference(String pubkey) {
    return ReplaceableEventReference(
      kind: UserChatRelaysEntity.kind,
      pubkey: pubkey,
    );
  }

  static List<String> toRelayTag(UserRelay relay) => ['relay', relay.url];
  static UserRelay fromRelayTag(List<String> tag) => UserRelay(url: tag[1]);
}
