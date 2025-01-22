// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_request_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/quoted_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/user/model/follow_list.c.dart';

part 'event_count_result_data.c.freezed.dart';

enum EventCountResultType {
  replies,
  reposts,
  quotes,
  followers,
  reactions;
}

@Freezed(equal: false)
class EventCountResultEntity
    with _$EventCountResultEntity, IonConnectEntity, ImmutableEntity, CacheableEntity {
  const factory EventCountResultEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required DateTime createdAt,
    required EventCountResultSummary data,
  }) = _EventCountResultEntity;

  const EventCountResultEntity._();

  /// https://github.com/nostr-protocol/nips/blob/vending-machine/90.md
  factory EventCountResultEntity.fromEventMessage(
    EventMessage eventMessage, {
    String? key,
  }) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventId: eventMessage.id, kind: kind);
    }

    final data = EventCountResultData.fromEventMessage(eventMessage);
    final type = data.getType();
    final summary = EventCountResultSummary(
      key: key ?? data.getKey(type),
      type: type,
      content: data.content,
      requestEventId: data.request.id,
    );

    return EventCountResultEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: summary,
    );
  }

  @override
  String get cacheKey => cacheKeyBuilder(key: data.key, type: data.type);

  static String cacheKeyBuilder({required String key, required EventCountResultType type}) =>
      '$key:${type.toShortString()}';

  static const int kind = 6400;
}

@freezed
class EventCountResultSummary with _$EventCountResultSummary {
  const factory EventCountResultSummary({
    required dynamic content,
    required String key,
    required String requestEventId,
    required EventCountResultType type,
  }) = _EventCountResultSummary;
}

@freezed
class EventCountResultData with _$EventCountResultData {
  const factory EventCountResultData({
    required EventCountRequestEntity request,
    required dynamic content,
    required String eventId,
    required String pubkey,
  }) = _EventCountResultData;

  const EventCountResultData._();

  factory EventCountResultData.fromEventMessage(EventMessage eventMessage) {
    EventCountRequestEntity? request;
    String? eventId;
    String? pubkey;

    for (final tag in eventMessage.tags) {
      if (tag[0] == 'request') {
        request = EventCountRequestEntity.fromEventMessage(
          EventMessage.fromPayloadJson(jsonDecode(tag[1]) as Map<String, dynamic>),
        );
      }
      if (tag[0] == 'e') eventId = tag[1];
      if (tag[0] == 'p') pubkey = tag[1];
    }

    if (request == null || eventId == null || pubkey == null) {
      throw IncorrectEventTagsException(eventId: eventMessage.id);
    }

    return EventCountResultData(
      content: jsonDecode(eventMessage.content),
      request: request,
      eventId: eventId,
      pubkey: pubkey,
    );
  }

  EventCountResultType getType() {
    final EventCountRequestData(:filters, :params) = request.data;
    final filter = filters.first;
    if (params?.group == RelatedEventMarker.reply.toShortString() ||
        params?.group == RelatedEventMarker.root.toShortString()) {
      return EventCountResultType.replies;
    } else if (filter.kinds != null &&
        filter.kinds!.contains(RepostEntity.kind) &&
        params?.group == RelatedEvent.tagName) {
      return EventCountResultType.reposts;
    } else if (params?.group == QuotedEvent.tagName) {
      return EventCountResultType.quotes;
    } else if (filter.kinds != null && filter.kinds!.contains(ReactionEntity.kind)) {
      return EventCountResultType.reactions;
    } else if (filter.kinds != null && filter.kinds!.contains(FollowListEntity.kind)) {
      return EventCountResultType.followers;
    } else {
      throw UnknownEventCountResultType(eventId: eventId);
    }
  }

  String getKey(EventCountResultType type) {
    final tags = request.data.filters.first.tags;
    if (tags == null || tags.isEmpty) {
      throw UnknownEventCountResultKey(eventId: eventId);
    }

    final qTag = tags['#q'];
    final pTag = tags['#p'];
    final eTag = tags['#e'];

    final key = switch (type) {
      EventCountResultType.quotes => qTag != null && qTag.isNotEmpty ? qTag.first : null,
      EventCountResultType.followers => pTag != null && pTag.isNotEmpty ? pTag.first : null,
      _ => eTag != null && eTag.isNotEmpty ? eTag.first : null,
    };

    if (key == null) {
      throw UnknownEventCountResultKey(eventId: eventId);
    }

    return key;
  }
}
