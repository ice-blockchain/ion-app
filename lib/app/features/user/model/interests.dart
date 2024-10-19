// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'interests.freezed.dart';

@freezed
class Interests with _$Interests, CacheableEvent {
  const factory Interests({
    required String pubkey,
    required List<String> hashtags,
    required List<String> interestSetRefs,
  }) = _Interests;

  /// https://github.com/nostr-protocol/nips/blob/master/51.md#standard-lists
  factory Interests.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw Exception('Incorrect event with kind ${eventMessage.kind}, expected $kind');
    }

    return Interests(
      pubkey: eventMessage.pubkey,
      interestSetRefs:
          eventMessage.tags.where((tag) => tag[0] == 'a').map((tag) => tag[1]).toList(),
      hashtags: eventMessage.tags.where((tag) => tag[0] == 't').map((tag) => tag[1]).toList(),
    );
  }

  const Interests._();

  EventMessage toEventMessage(KeyStore keyStore) {
    return EventMessage.fromData(
      signer: keyStore,
      kind: kind,
      tags: [
        ...interestSetRefs.map((id) => ['a', id]),
        ...hashtags.map((hashtag) => ['t', hashtag]),
      ],
      content: '',
    );
  }

  @override
  String get cacheKey => pubkey;

  @override
  Type get cacheType => Interests;

  static const int kind = 10015;
}
