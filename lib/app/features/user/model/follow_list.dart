// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/nostr/model/event_serializable.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'follow_list.freezed.dart';

@Freezed(equal: false)
class FollowListEntity with _$FollowListEntity, NostrEntity implements CacheableEntity {
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
      throw IncorrectEventKindException(eventId: eventMessage.id, kind: kind);
    }

    return FollowListEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig,
      createdAt: eventMessage.createdAt,
      data: FollowListData.fromEventMessage(eventMessage),
    );
  }

  List<String> get pubkeys => data.list.map((followee) => followee.pubkey).toList();

  @override
  String get cacheKey => cacheKeyBuilder(pubkey: masterPubkey);

  static String cacheKeyBuilder({required String pubkey}) => '$kind:$pubkey';

  static const int kind = 3;
}

@freezed
class FollowListData with _$FollowListData implements EventSerializable {
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
  FutureOr<EventMessage> toEventMessage(EventSigner signer, {List<List<String>> tags = const []}) {
    return EventMessage.fromData(
      signer: signer,
      kind: FollowListEntity.kind,
      tags: [
        ...tags,
        ...list.map((followee) => followee.toTag()),
      ],
      content: '',
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
