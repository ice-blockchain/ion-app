// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/community_identifier_tag.c.dart';
import 'package:ion/app/features/chat/model/message_type.dart';
import 'package:ion/app/features/chat/model/related_subject.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/entity_data_with_media_content.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_pubkey.c.dart';
import 'package:ion/app/features/ion_connect/model/rich_text.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_protocol_identifier_type.dart';
import 'package:ion/app/services/uuid/uuid.dart';
import 'package:ion/app/utils/string.dart';

part 'private_direct_message_data.c.freezed.dart';

@immutable
@Freezed(equal: false)
class PrivateDirectMessageEntity with _$PrivateDirectMessageEntity {
  const factory PrivateDirectMessageEntity({
    required String id,
    required String pubkey,
    required DateTime createdAt,
    required PrivateDirectMessageData data,
  }) = _PrivateDirectMessageEntity;

  const PrivateDirectMessageEntity._();

  factory PrivateDirectMessageEntity.fromEventMessage(
    EventMessage eventMessage,
  ) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventMessage.id, kind: kind);
    }

    return PrivateDirectMessageEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      createdAt: eventMessage.createdAt,
      data: PrivateDirectMessageData.fromEventMessage(eventMessage),
    );
  }

  static const kind = 14;

  List<String> get allPubkeys {
    return data.relatedPubkeys?.map((pubkey) => pubkey.value).toList() ?? []
      ..sort();
  }

  @override
  bool operator ==(Object other) {
    return other is PrivateDirectMessageEntity && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

@freezed
class PrivateDirectMessageData with _$PrivateDirectMessageData, EntityDataWithMediaContent {
  const factory PrivateDirectMessageData({
    required String uuid,
    required String content,
    required Map<String, MediaAttachment> media,
    RichText? richText,
    String? relatedGroupImagePath,
    RelatedSubject? relatedSubject,
    List<RelatedEvent>? relatedEvents,
    List<RelatedPubkey>? relatedPubkeys,
    CommunityIdentifierTag? relatedConversationId,
  }) = _PrivateDirectMessageData;

  factory PrivateDirectMessageData.fromEventMessage(EventMessage eventMessage) {
    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);

    return PrivateDirectMessageData(
      content: eventMessage.content,
      media: EntityDataWithMediaContent.parseImeta(tags[MediaAttachment.tagName]),
      relatedSubject: tags[RelatedSubject.tagName]?.map(RelatedSubject.fromTag).singleOrNull,
      relatedPubkeys: tags[RelatedPubkey.tagName]?.map(RelatedPubkey.fromTag).toList(),
      relatedEvents: tags[RelatedImmutableEvent.tagName]?.map(RelatedEvent.fromTag).toList(),
      uuid:
          tags[CommunityIdentifierTag.tagName]?.map(CommunityIdentifierTag.fromTag).single.value ??
              '',
    );
  }

  factory PrivateDirectMessageData.fromRawContent(String content) {
    return PrivateDirectMessageData(
      content: content,
      media: {},
      uuid: generateUuid(),
    );
  }

  const PrivateDirectMessageData._();

  FutureOr<EventMessage> toEventMessage({
    required String pubkey,
  }) {
    final eventTags = [
      if (relatedPubkeys != null) ...relatedPubkeys!.map((pubkey) => pubkey.toTag()),
      if (relatedEvents != null) ...relatedEvents!.map((event) => event.toTag()),
      if (media.isNotEmpty) ...media.values.map((mediaAttachment) => mediaAttachment.toTag()),
      CommunityIdentifierTag(value: uuid).toTag(),
    ];

    final createdAt = DateTime.now();

    final kind14EventId = EventMessage.calculateEventId(
      publicKey: pubkey,
      createdAt: createdAt,
      kind: PrivateDirectMessageEntity.kind,
      tags: eventTags,
      content: content,
    );

    return EventMessage(
      id: kind14EventId,
      pubkey: pubkey,
      createdAt: createdAt,
      kind: PrivateDirectMessageEntity.kind,
      tags: eventTags,
      content: content,
      sig: null,
    );
  }

  MessageType get messageType {
    if (primaryAudio != null) {
      return MessageType.audio;
    } else if (IonConnectProtocolIdentifierTypeValidator.isProfileIdentifier(content)) {
      return MessageType.profile;
    } else if (content.isEmoji) {
      return MessageType.emoji;
    } else if (visualMedias.isNotEmpty) {
      return MessageType.visualMedia;
    } else if (media.isNotEmpty) {
      return MessageType.document;
    }

    return MessageType.text;
  }

  static const textMessageLimit = 4096;
  static const videoDurationLimitInSeconds = 300;
}
