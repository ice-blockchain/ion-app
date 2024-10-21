// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'follow_list.freezed.dart';

@freezed
class FollowList with _$FollowList, CacheableEvent {
  const factory FollowList({
    required String pubkey,
    required List<Followee> list,
  }) = _FollowList;

  /// https://github.com/nostr-protocol/nips/blob/master/02.md
  factory FollowList.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw Exception('Incorrect event with kind ${eventMessage.kind}, expected $kind');
    }

    return FollowList(
      pubkey: eventMessage.pubkey,
      list: eventMessage.tags.map(Followee.fromTag).toList(),
    );
  }

  const FollowList._();

  EventMessage toEventMessage(KeyStore keyStore) {
    return EventMessage.fromData(
      signer: keyStore,
      kind: kind,
      tags: list.map((followee) => followee.toTag()).toList(),
      content: '',
    );
  }

  @override
  String get cacheKey => pubkey;

  @override
  Type get cacheType => FollowList;

  static const int kind = 3;
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
