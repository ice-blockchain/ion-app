// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'follow_list.freezed.dart';

@freezed
class FollowListEntity with _$FollowListEntity implements CacheableEntity, NostrEntity {
  const factory FollowListEntity({
    required String id,
    required String pubkey,
    required DateTime createdAt,
    required FollowListData data,
  }) = _FollowListEntity;

  const FollowListEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/51.md#sets
  factory FollowListEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw Exception('Incorrect event with kind ${eventMessage.kind}, expected $kind');
    }

    return FollowListEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      createdAt: eventMessage.createdAt,
      data: FollowListData.fromEventMessage(eventMessage),
    );
  }

  @override
  String get cacheKey => pubkey;

  @override
  Type get cacheType => FollowListEntity;

  static const int kind = 3;
}

@freezed
class FollowListData with _$FollowListData {
  const factory FollowListData({
    required List<Followee> list,
  }) = _FollowListData;

  /// https://github.com/nostr-protocol/nips/blob/master/02.md
  factory FollowListData.fromEventMessage(EventMessage eventMessage) {
    return FollowListData(
      list: eventMessage.tags.map(Followee.fromTag).toList(),
    );
  }

  const FollowListData._();

  EventMessage toEventMessage(KeyStore keyStore) {
    return EventMessage.fromData(
      signer: keyStore,
      kind: FollowListEntity.kind,
      tags: list.map((followee) => followee.toTag()).toList(),
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
      throw Exception('Incorrect tag $tag, expected $tagName');
    }
    return Followee(pubkey: tag[1], relayUrl: tag[2], petname: tag[3]);
  }

  List<String> toTag() {
    return [tagName, pubkey, relayUrl, petname];
  }

  static const String tagName = 'p';
}
