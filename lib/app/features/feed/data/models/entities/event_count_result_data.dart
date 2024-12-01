// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_request_data.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.dart';
import 'package:ion/app/features/feed/data/models/entities/related_event.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'event_count_result_data.freezed.dart';

enum EventCountResultType {
  replies,
  reposts,
  quotes,
  reactions;
}

@Freezed(equal: false)
class EventCountResultEntity with _$EventCountResultEntity, NostrEntity implements CacheableEntity {
  const factory EventCountResultEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required DateTime createdAt,
    required EventCountResultSummary data,
  }) = _EventCountResultEntity;

  const EventCountResultEntity._();

  /// https://github.com/nostr-protocol/nips/blob/vending-machine/90.md
  factory EventCountResultEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventId: eventMessage.id, kind: kind);
    }

    final data = EventCountResultData.fromEventMessage(eventMessage);
    final type = data.getType();
    final summary = EventCountResultSummary(
      key: data.getKey(type),
      type: type,
      content: data.content,
    );

    return EventCountResultEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: NostrEntity.getMasterPubkey(eventMessage),
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
          EventMessage.fromJson(jsonDecode(tag[1]) as List<dynamic>),
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
    final EventCountRequestData(:filter, :params) = request.data;
    if (params.group == RelatedEventMarker.reply.toShortString() ||
        params.group == RelatedEventMarker.root.toShortString()) {
      return EventCountResultType.replies;
    } else if (filter.kinds != null &&
        filter.kinds!.contains(RepostEntity.kind) &&
        params.group == RelatedEvent.tagName) {
      return EventCountResultType.reposts;
    } else if (params.group == QuotedEvent.tagName) {
      return EventCountResultType.quotes;
    } else if (filter.kinds != null && filter.kinds!.contains(ReactionEntity.kind)) {
      return EventCountResultType.reactions;
    } else {
      throw UnknownEventCountResultType(eventId: eventId);
    }
  }

  String getKey(EventCountResultType type) {
    final filter = request.data.filter;
    final key = switch (type) {
      EventCountResultType.quotes =>
        filter.q != null && filter.q!.isNotEmpty ? filter.q!.first : null,
      _ => filter.e != null && filter.e!.isNotEmpty ? filter.e!.first : null,
    };
    if (key == null) {
      throw UnknownEventCountResultKey(eventId: eventId);
    }
    return key;
  }
}
