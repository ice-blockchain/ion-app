// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/nostr/model/event_serializable.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'interests.freezed.dart';

@freezed
class InterestsEntity with _$InterestsEntity implements CacheableEntity, NostrEntity {
  const factory InterestsEntity({
    required String id,
    required String pubkey,
    required DateTime createdAt,
    required InterestsData data,
  }) = _InterestsEntity;

  const InterestsEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/51.md#standard-lists
  factory InterestsEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventId: eventMessage.id, kind: kind);
    }

    return InterestsEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      createdAt: eventMessage.createdAt,
      data: InterestsData.fromEventMessage(eventMessage),
    );
  }

  @override
  String get cacheKey => pubkey;

  @override
  Type get cacheType => InterestsEntity;

  static const int kind = 10015;
}

@freezed
class InterestsData with _$InterestsData implements EventSerializable {
  const factory InterestsData({
    required List<String> hashtags,
    required List<String> interestSetRefs,
  }) = _InterestsData;

  const InterestsData._();

  factory InterestsData.fromEventMessage(EventMessage eventMessage) {
    return InterestsData(
      interestSetRefs:
          eventMessage.tags.where((tag) => tag[0] == 'a').map((tag) => tag[1]).toList(),
      hashtags: eventMessage.tags.where((tag) => tag[0] == 't').map((tag) => tag[1]).toList(),
    );
  }

  @override
  EventMessage toEventMessage(EventSigner signer) {
    return EventMessage.fromData(
      signer: signer,
      kind: InterestsEntity.kind,
      tags: [
        ...interestSetRefs.map((id) => ['a', id]),
        ...hashtags.map((hashtag) => ['t', hashtag]),
      ],
      content: '',
    );
  }
}
