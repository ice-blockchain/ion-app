// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/extensions/enum.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'interest_set.freezed.dart';

enum InterestSetType { languages, unknown }

@freezed
class InterestSet with _$InterestSet, CacheableEvent {
  const factory InterestSet({
    required String pubkey,
    required InterestSetType type,
    required List<String> hashtags,
  }) = _InterestSet;

  /// https://github.com/nostr-protocol/nips/blob/master/51.md#sets
  factory InterestSet.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw Exception('Incorrect event with kind ${eventMessage.kind}, expected $kind');
    }

    final typeName = eventMessage.tags.firstWhereOrNull((tag) => tag[0] == 'd')?[1];

    if (typeName == null) {
      throw Exception('InterestSet event should have `d` tag');
    }

    return InterestSet(
      pubkey: eventMessage.pubkey,
      type: InterestSetType.values.asNameMap()[typeName] ?? InterestSetType.unknown,
      hashtags: eventMessage.tags.where((tag) => tag[0] == 't').map((tag) => tag[1]).toList(),
    );
  }

  const InterestSet._();

  EventMessage toEventMessage(KeyStore keyStore) {
    return EventMessage.fromData(
      signer: keyStore,
      kind: kind,
      tags: [
        ['d', type.toShortString()],
        ...hashtags.map((hashtag) => ['t', hashtag]),
      ],
      content: '',
    );
  }

  @override
  String get cacheKey => '$pubkey$type';

  @override
  Type get cacheType => InterestSet;

  static const int kind = 30015;
}
