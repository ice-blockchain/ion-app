// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/nostr/model/event_serializable.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.c.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'event_count_request_data.c.freezed.dart';

@Freezed(equal: false)
class EventCountRequestEntity
    with _$EventCountRequestEntity, NostrEntity
    implements CacheableEntity {
  const factory EventCountRequestEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required DateTime createdAt,
    required EventCountRequestData data,
  }) = _EventCountRequestEntity;

  const EventCountRequestEntity._();

  /// https://github.com/nostr-protocol/nips/blob/vending-machine/90.md
  factory EventCountRequestEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventId: eventMessage.id, kind: kind);
    }

    return EventCountRequestEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: EventCountRequestData.fromEventMessage(eventMessage),
    );
  }

  @override
  String get cacheKey => cacheKeyBuilder(id: id);

  static String cacheKeyBuilder({required String id}) => id;

  static const int kind = 5400;
}

@freezed
class EventCountRequestData with _$EventCountRequestData implements EventSerializable {
  const factory EventCountRequestData({
    required List<RequestFilter> filters,
    required EventCountRequestParams params,
    String? output,
  }) = _EventCountRequestData;

  const EventCountRequestData._();

  factory EventCountRequestData.fromEventMessage(EventMessage eventMessage) {
    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);
    final filters = (jsonDecode(eventMessage.content) as List<dynamic>)
        .map((filterJson) => RequestFilter.fromJson(filterJson as Map<String, dynamic>))
        .toList();
    return EventCountRequestData(
      filters: filters,
      params: EventCountRequestParams.fromTags(tags[EventCountRequestParams.tagName] ?? []),
      output: tags['output']?.first[1],
    );
  }

  @override
  @override
  FutureOr<EventMessage> toEventMessage(
    EventSigner signer, {
    List<List<String>> tags = const [],
    DateTime? createdAt,
  }) {
    return EventMessage.fromData(
      signer: signer,
      createdAt: createdAt,
      kind: EventCountRequestEntity.kind,
      content: json.encode(filters.map((filter) => filter.toString())),
      tags: [...tags, ...params.toTags()],
    );
  }
}

@freezed
class EventCountRequestParams with _$EventCountRequestParams {
  const factory EventCountRequestParams({
    String? relay,
    String? group,
  }) = _EventCountRequestParams;

  const EventCountRequestParams._();

  factory EventCountRequestParams.fromTags(List<List<String>> tags) {
    String? relay;
    String? group;
    for (final tag in tags) {
      if (tag[0] == tagName) {
        if (tag.length != 3) {
          throw IncorrectEventTagException(tag: tag.toString());
        }
        if (tag[1] == 'group') group = tag[2];
        if (tag[1] == 'relay') relay = tag[2];
      }
    }

    return EventCountRequestParams(
      relay: relay,
      group: group,
    );
  }

  List<List<String>> toTags() {
    return [
      if (group != null) [tagName, 'group', group!],
      if (relay != null) [tagName, 'relay', relay!],
    ];
  }

  static const String tagName = 'param';
}
