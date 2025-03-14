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

part 'follow_list.c.freezed.dart';

@Freezed(equal: false)
class FollowListEntity
    with IonConnectEntity, CacheableEntity, ReplaceableEntity, _$FollowListEntity {
  const factory FollowListEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required DateTime createdAt,
    required FollowListData data,
  }) = _FollowListEntity;

  const FollowListEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/02.md
  factory FollowListEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventMessage.id, kind: kind);
    }

    return FollowListEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: FollowListData.fromEventMessage(eventMessage),
    );
  }

  List<String> get pubkeys => data.list.map((followee) => followee.pubkey).toList();

  static const int kind = 3;
}

@freezed
class FollowListData with _$FollowListData implements EventSerializable, ReplaceableEntityData {
  const factory FollowListData({
    required List<Followee> list,
  }) = _FollowListData;

  factory FollowListData.fromEventMessage(EventMessage eventMessage) {
    return FollowListData(
      list: [
        for (final tag in eventMessage.tags)
          if (tag[0] == Followee.tagName) Followee.fromTag(tag),
      ],
    );
  }

  const FollowListData._();

  @override
  FutureOr<EventMessage> toEventMessage(
    EventSigner signer, {
    List<List<String>> tags = const [],
    DateTime? createdAt,
  }) {
    return EventMessage.fromData(
      signer: signer,
      createdAt: createdAt,
      kind: FollowListEntity.kind,
      tags: [
        ...tags,
        ...list.map((followee) => followee.toTag()),
      ],
    );
  }

  @override
  ReplaceableEventReference toReplaceableEventReference(String pubkey) {
    return ReplaceableEventReference(
      kind: FollowListEntity.kind,
      pubkey: pubkey,
    );
  }
}

@freezed
class Followee with _$Followee {
  const factory Followee({
    required String pubkey,
    @Default('') String relayUrl,
    @Default('') String petname,
  }) = _Followee;

  const Followee._();

  factory Followee.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    return Followee(pubkey: tag[1], relayUrl: tag[2], petname: tag[3]);
  }

  List<String> toTag() {
    return [tagName, pubkey, relayUrl, petname];
  }

  static const String tagName = 'p';
}
