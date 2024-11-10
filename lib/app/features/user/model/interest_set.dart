// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/enum.dart';
import 'package:ion/app/features/nostr/model/event_serializable.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'interest_set.freezed.dart';

enum InterestSetType { languages, unknown }

@freezed
class InterestSetEntity with _$InterestSetEntity implements CacheableEntity, NostrEntity {
  const factory InterestSetEntity({
    required String id,
    required String pubkey,
    required DateTime createdAt,
    required InterestSetData data,
  }) = _InterestSetEntity;

  const InterestSetEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/51.md#sets
  factory InterestSetEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventId: eventMessage.id, kind: kind);
    }

    return InterestSetEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      createdAt: eventMessage.createdAt,
      data: InterestSetData.fromEventMessage(eventMessage),
    );
  }

  @override
  String get cacheKey => '$pubkey${data.type}';

  @override
  Type get cacheType => InterestSetEntity;

  static const int kind = 30015;
}

@freezed
class InterestSetData with _$InterestSetData implements EventSerializable {
  const factory InterestSetData({
    required InterestSetType type,
    required List<String> hashtags,
  }) = _InterestSetData;

  const InterestSetData._();

  factory InterestSetData.fromEventMessage(EventMessage eventMessage) {
    final typeName = eventMessage.tags.firstWhereOrNull((tag) => tag[0] == 'd')?[1];

    if (typeName == null) {
      throw Exception('InterestSet event should have `d` tag');
    }

    return InterestSetData(
      type: InterestSetType.values.asNameMap()[typeName] ?? InterestSetType.unknown,
      hashtags: eventMessage.tags.where((tag) => tag[0] == 't').map((tag) => tag[1]).toList(),
    );
  }

  @override
  EventMessage toEventMessage(EventSigner signer) {
    return EventMessage.fromData(
      signer: signer,
      kind: InterestSetEntity.kind,
      tags: [
        ['d', type.toShortString()],
        ...hashtags.map((hashtag) => ['t', hashtag]),
      ],
      content: '',
    );
  }
}
