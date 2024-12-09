// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/related_event.c.dart';
import 'package:ion/app/features/feed/data/models/entities/related_pubkey.c.dart';
import 'package:ion/app/features/nostr/model/entity_media_data.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/services/text_parser/text_match.dart';
import 'package:ion/app/services/text_parser/text_parser.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'private_direct_message_data.c.freezed.dart';

@Freezed(equal: false)
class PrivateDirectMessageEntity with _$PrivateDirectMessageEntity, NostrEntity {
  const factory PrivateDirectMessageEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required DateTime createdAt,
    required PrivateDirectMessageData data,
  }) = _PrivateDirectMessageEntity;

  const PrivateDirectMessageEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/17.md
  factory PrivateDirectMessageEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw Exception('Incorrect event kind ${eventMessage.kind}, expected $kind');
    }

    return PrivateDirectMessageEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: PrivateDirectMessageData.fromEventMessage(eventMessage),
    );
  }

  static const kind = 14;
}

@freezed
class PrivateDirectMessageData with _$PrivateDirectMessageData, EntityMediaDataMixin {
  const factory PrivateDirectMessageData({
    required List<TextMatch> content,
    required Map<String, MediaAttachment> media,
    List<RelatedPubkey>? relatedPubkeys,
    List<RelatedEvent>? relatedEvents,
  }) = _PrivateDirectMessageData;

  factory PrivateDirectMessageData.fromEventMessage(EventMessage eventMessage) {
    final parsedContent = TextParser.allMatchers().parse(eventMessage.content);

    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);

    return PrivateDirectMessageData(
      content: parsedContent,
      media: EntityMediaDataMixin.buildMedia(tags[MediaAttachment.tagName], parsedContent),
      relatedPubkeys: tags[RelatedPubkey.tagName]?.map(RelatedPubkey.fromTag).toList(),
      relatedEvents: tags[RelatedEvent.tagName]?.map(RelatedEvent.fromTag).toList(),
    );
  }

  const PrivateDirectMessageData._();

  List<MediaAttachment> get medias => media.values.toList();
  @override
  MediaAttachment? get primaryMedia => medias.firstOrNull;

  FutureOr<EventMessage> toEventMessage({
    required String pubkey,
  }) {
    final eventTags = [
      if (relatedPubkeys != null) ...relatedPubkeys!.map((pubkey) => pubkey.toTag()),
      if (relatedEvents != null) ...relatedEvents!.map((event) => event.toTag()),
      if (media.isNotEmpty) ...media.values.map((mediaAttachment) => mediaAttachment.toTag()),
    ];

    final createdAt = DateTime.now();
    final contentString = content.map((match) => match.text).join();

    final kind14EventId = EventMessage.calculateEventId(
      publicKey: pubkey,
      createdAt: createdAt,
      kind: PrivateDirectMessageEntity.kind,
      tags: eventTags,
      content: contentString,
    );

    return EventMessage(
      id: kind14EventId,
      pubkey: pubkey,
      createdAt: createdAt,
      kind: PrivateDirectMessageEntity.kind,
      tags: eventTags,
      content: contentString,
      sig: null,
    );
  }
}
