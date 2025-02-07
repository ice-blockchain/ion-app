// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'event_count_error_entity.c.freezed.dart';

@Freezed(equal: false)
class EventCountErrorEntity
    with _$EventCountErrorEntity, IonConnectEntity, ImmutableEntity, CacheableEntity {
  const factory EventCountErrorEntity({
    required String id,
    required String pubkey,
    required String signature,
    required String masterPubkey,
    required DateTime createdAt,
    required EventCountResultSummary data,
  }) = _EventCountErrorEntity;

  const EventCountErrorEntity._();

  /// https://github.com/nostr-protocol/nips/blob/vending-machine/90.md
  factory EventCountErrorEntity.fromEventMessage(
    EventMessage eventMessage, {
    String? key,
  }) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventMessage.id, kind: kind);
    }

    final data = EventCountResultData.fromEventMessage(eventMessage);
    final type = data.getType();
    final summary = EventCountResultSummary(
      key: key ?? data.getKey(type),
      type: type,
      content: data.content,
      requestEventId: data.request.id,
    );

    return EventCountErrorEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      signature: eventMessage.sig!,
      masterPubkey: eventMessage.masterPubkey,
      createdAt: eventMessage.createdAt,
      data: summary,
    );
  }

  @override
  String get cacheKey => cacheKeyBuilder(key: data.key, type: data.type);

  static String cacheKeyBuilder({required String key, required EventCountResultType type}) =>
      '$key:${type.toShortString()}';

  static const int kind = 7000;
}
