// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/community/models/entities/community_join_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_request_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/user/model/follow_list.c.dart';

part 'event_count_result_data.c.freezed.dart';

enum EventCountResultType {
  replies,
  reposts,
  quotes,
  followers,
  reactions,
  members;
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
  CacheableEntityOptions get cacheOptions {
    return CacheableEntityOptions(
      cacheKey: cacheKeyBuilder(key: data.key, type: data.type),
    );
  }

  static String cacheKeyBuilder({required String key, required EventCountResultType type}) =>
      '$key:${type.toShortString()}';

  // @override
  // Duration get expirationDuration => const Duration(days: 1);

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
    required EventReference eventReference,
    required String pubkey,
  }) = _EventCountResultData;

  const EventCountResultData._();

  factory EventCountResultData.fromEventMessage(EventMessage eventMessage) {
    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);
    final pubkey = tags['p']!.first[1];
    final eventRef = tags['a']?.first[1];
    final eventId = tags['e']?.first[1];
    final request = EventCountRequestEntity.fromEventMessage(
      EventMessage.fromPayloadJson(jsonDecode(tags['request']!.first[1]) as Map<String, dynamic>),
    );

    final eventReference = eventRef != null
        ? ReplaceableEventReference.fromString(eventRef)
        : eventId != null
            ? ImmutableEventReference(eventId: eventId, pubkey: pubkey)
            : null;

    if (eventReference == null) {
      throw IncorrectEventTagsException(eventId: eventMessage.id);
    }

    return EventCountResultData(
      content: jsonDecode(eventMessage.content),
      request: request,
      eventReference: eventReference,
      pubkey: pubkey,
    );
  }

  EventCountResultType getType() {
    final EventCountRequestData(:filters, :params) = request.data;
    final filter = filters.first;
    if (filter.kinds != null && filter.kinds!.contains(GenericRepostEntity.kind)) {
      return EventCountResultType.reposts;
    } else if (filter.kinds != null && filter.kinds!.contains(ReactionEntity.kind)) {
      return EventCountResultType.reactions;
    } else if (filter.kinds != null && filter.kinds!.contains(FollowListEntity.kind)) {
      return EventCountResultType.followers;
    } else if (filter.tags != null && filter.tags!.containsKey('#a')) {
      return EventCountResultType.replies;
    } else if (filter.tags != null && filter.tags!.containsKey('#q')) {
      return EventCountResultType.quotes;
    } else if (filter.kinds != null && filter.kinds!.contains(CommunityJoinEntity.kind)) {
      return EventCountResultType.members;
    } else {
      throw UnknownEventCountResultType(eventReference);
    }
  }

  String getKey(EventCountResultType type) {
    final tags = request.data.filters.first.tags;
    if (tags == null || tags.isEmpty) {
      throw UnknownEventCountResultKey(eventReference);
    }

    final qTag = tags['#q'];
    final pTag = tags['#p'];
    final eTag = tags['#e'];
    final aTag = tags['#a'];

    final key = switch (type) {
      EventCountResultType.quotes =>
        qTag != null && qTag.isNotEmpty ? (qTag.first! as List<dynamic>).first : null,
      EventCountResultType.followers =>
        pTag != null && pTag.isNotEmpty ? (pTag.first! as List<dynamic>).first : null,
      _ when eTag != null => eTag.isNotEmpty ? (eTag.first! as List<dynamic>).first : null,
      _ when aTag != null => aTag.isNotEmpty ? (aTag.first! as List<dynamic>).first : null,
      _ => null
    } as String?;

    if (key == null) {
      throw UnknownEventCountResultKey(eventReference);
    }

    return key;
  }
}
