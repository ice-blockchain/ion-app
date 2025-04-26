// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/conversation_identifier.c.dart';
import 'package:ion/app/features/chat/model/group_subject.c.dart';
import 'package:ion/app/features/chat/model/message_type.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/entity_data_with_media_content.dart';
import 'package:ion/app/features/ion_connect/model/entity_data_with_parent.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/model/quoted_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_pubkey.c.dart';
import 'package:ion/app/features/ion_connect/model/replaceable_event_identifier.c.dart';
import 'package:ion/app/features/ion_connect/model/rich_text.c.dart';
import 'package:ion/app/features/wallets/model/entities/funds_request_entity.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_protocol_identifier_type.dart';
import 'package:ion/app/services/uuid/uuid.dart';
import 'package:ion/app/utils/string.dart';

part 'private_direct_message_data.c.freezed.dart';

@immutable
abstract class PrivateDirectMessageEntity {
  factory PrivateDirectMessageEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind == ImmutablePrivateDirectMessageEntity.kind) {
      return ImmutablePrivateDirectMessageEntity.fromEventMessage(eventMessage);
    } else if (eventMessage.kind == ReplaceablePrivateDirectMessageEntity.kind) {
      return ReplaceablePrivateDirectMessageEntity.fromEventMessage(eventMessage);
    } else {
      throw IncorrectEventKindException(eventMessage.id, kind: eventMessage.kind);
    }
  }

  String get id;
  String get pubkey;
  String get masterPubkey;
  DateTime get createdAt;
  PrivateDirectMessageData get data;

  @override
  bool operator ==(Object other) {
    return other is PrivateDirectMessageEntity && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

extension Pubkeys on PrivateDirectMessageEntity {
  List<String> get allPubkeys => data.relatedPubkeys?.map((pubkey) => pubkey.value).toList() ?? []
    ..sort();
}

@freezed
class ImmutablePrivateDirectMessageEntity
    with _$ImmutablePrivateDirectMessageEntity
    implements PrivateDirectMessageEntity {
  const factory ImmutablePrivateDirectMessageEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required DateTime createdAt,
    required PrivateDirectMessageData data,
  }) = _ImmutablePrivateDirectMessageEntity;

  const ImmutablePrivateDirectMessageEntity._();

  factory ImmutablePrivateDirectMessageEntity.fromEventMessage(EventMessage eventMessage) {
    return ImmutablePrivateDirectMessageEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      createdAt: eventMessage.createdAt,
      data: ImmutablePrivateDirectMessageData.fromEventMessage(eventMessage),
    );
  }

  static const kind = 14;
}

@freezed
class ReplaceablePrivateDirectMessageEntity
    with _$ReplaceablePrivateDirectMessageEntity
    implements PrivateDirectMessageEntity {
  const factory ReplaceablePrivateDirectMessageEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required DateTime createdAt,
    required PrivateDirectMessageData data,
  }) = _ReplaceablePrivateDirectMessageEntity;

  const ReplaceablePrivateDirectMessageEntity._();

  factory ReplaceablePrivateDirectMessageEntity.fromEventMessage(EventMessage eventMessage) {
    return ReplaceablePrivateDirectMessageEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      createdAt: eventMessage.createdAt,
      data: ImmutablePrivateDirectMessageData.fromEventMessage(eventMessage),
    );
  }

  static const kind = 30014;
}

// -----------------------------------------------------------------------------
@immutable
abstract class PrivateDirectMessageData
    with EntityDataWithMediaContent, EntityDataWithRelatedEvents {
  factory PrivateDirectMessageData.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind == ImmutablePrivateDirectMessageEntity.kind) {
      return ImmutablePrivateDirectMessageData.fromEventMessage(eventMessage);
    } else if (eventMessage.kind == ReplaceablePrivateDirectMessageEntity.kind) {
      return ImmutablePrivateDirectMessageData.fromEventMessage(eventMessage);
    } else {
      throw IncorrectEventKindException(eventMessage.id, kind: eventMessage.kind);
    }
  }

  factory PrivateDirectMessageData.fromRawContent(String content) {
    return ImmutablePrivateDirectMessageData(
      content: content,
      media: {},
      conversationId: generateUuid(),
    );
  }

  FutureOr<EventMessage> toEventMessage(String pubkey);

  String get conversationId;
  String? get groupImagePath;
  GroupSubject? get groupSubject;
  QuotedImmutableEvent? get quotedEvent;
  @override
  List<RelatedEvent>? get relatedEvents;
  List<RelatedPubkey>? get relatedPubkeys;

  static const textMessageLimit = 4096;
  static const videoDurationLimitInSeconds = 300;
  static const audioMessageDurationLimitInSeconds = 300;
  static const fileMessageSizeLimit = 25 * 1024 * 1024;
}

extension MessageTypes on PrivateDirectMessageData {
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
    } else if (IonConnectProtocolIdentifierTypeValidator.isEventIdentifier(content)) {
      if (EventReference.fromEncoded(content) case final ImmutableEventReference eventReference) {
        return switch (eventReference.kind) {
          FundsRequestEntity.kind => MessageType.requestFunds,
          _ => MessageType.text,
        };
      }
    } else if (quotedEvent != null) {
      return MessageType.storyReply;
    }

    return MessageType.text;
  }
}

@freezed
class ImmutablePrivateDirectMessageData
    with
        _$ImmutablePrivateDirectMessageData,
        EntityDataWithMediaContent,
        EntityDataWithRelatedEvents
    implements PrivateDirectMessageData {
  const factory ImmutablePrivateDirectMessageData({
    required String content,
    required String conversationId,
    required Map<String, MediaAttachment> media,
    RichText? richText,
    String? groupImagePath,
    GroupSubject? groupSubject,
    QuotedImmutableEvent? quotedEvent,
    List<RelatedEvent>? relatedEvents,
    List<RelatedPubkey>? relatedPubkeys,
  }) = _ImmutablePrivateDirectMessageData;

  const ImmutablePrivateDirectMessageData._();

  factory ImmutablePrivateDirectMessageData.fromEventMessage(EventMessage eventMessage) {
    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);

    return ImmutablePrivateDirectMessageData(
      content: eventMessage.content,
      media: EntityDataWithMediaContent.parseImeta(tags[MediaAttachment.tagName]),
      relatedPubkeys: tags[RelatedPubkey.tagName]?.map(RelatedPubkey.fromTag).toList(),
      relatedEvents: tags[RelatedImmutableEvent.tagName]?.map(RelatedEvent.fromTag).toList(),
      groupSubject: tags[GroupSubject.tagName]?.map(GroupSubject.fromTag).singleOrNull,
      quotedEvent:
          tags[QuotedImmutableEvent.tagName]?.map(QuotedImmutableEvent.fromTag).singleOrNull,
      conversationId: tags[ConversationIdentifier.tagName]
              ?.map(ConversationIdentifier.fromTag)
              .singleOrNull
              ?.value ??
          '',
    );
  }

  @override
  FutureOr<EventMessage> toEventMessage(String pubkey) {
    final tags = [
      if (quotedEvent != null) quotedEvent!.toTag(),
      if (groupSubject != null) groupSubject!.toTag(),
      if (relatedEvents != null) ...relatedEvents!.map((event) => event.toTag()),
      if (relatedPubkeys != null) ...relatedPubkeys!.map((pubkey) => pubkey.toTag()),
      if (media.isNotEmpty) ...media.values.map((mediaAttachment) => mediaAttachment.toTag()),
      ConversationIdentifier(value: conversationId).toTag(),
    ];

    final createdAt = DateTime.now();

    final kind14EventId = EventMessage.calculateEventId(
      tags: tags,
      content: content,
      publicKey: pubkey,
      createdAt: createdAt,
      kind: ImmutablePrivateDirectMessageEntity.kind,
    );

    return EventMessage(
      sig: null,
      tags: tags,
      pubkey: pubkey,
      content: content,
      id: kind14EventId,
      createdAt: createdAt,
      kind: ImmutablePrivateDirectMessageEntity.kind,
    );
  }
}

@freezed
class ReplaceablePrivateDirectMessageData
    with
        _$ReplaceablePrivateDirectMessageData,
        EntityDataWithMediaContent,
        EntityDataWithRelatedEvents
    implements PrivateDirectMessageData {
  const factory ReplaceablePrivateDirectMessageData({
    required String content,
    required String messageId,
    required String conversationId,
    required Map<String, MediaAttachment> media,
    RichText? richText,
    String? groupImagePath,
    GroupSubject? groupSubject,
    QuotedImmutableEvent? quotedEvent,
    List<RelatedEvent>? relatedEvents,
    List<RelatedPubkey>? relatedPubkeys,
  }) = _ReplaceablePrivateDirectMessageData;

  const ReplaceablePrivateDirectMessageData._();

  factory ReplaceablePrivateDirectMessageData.fromEventMessage(EventMessage eventMessage) {
    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);

    if (tags[ReplaceableEventIdentifier.tagName] == null) {
      throw ReplaceablePrivateDirectMessageDecodeException(eventMessage.id);
    }

    return ReplaceablePrivateDirectMessageData(
      content: eventMessage.content,
      media: EntityDataWithMediaContent.parseImeta(tags[MediaAttachment.tagName]),
      messageId: tags[ReplaceableEventIdentifier.tagName]!
          .map(ReplaceableEventIdentifier.fromTag)
          .singleOrNull!
          .value,
      relatedPubkeys: tags[RelatedPubkey.tagName]?.map(RelatedPubkey.fromTag).toList(),
      relatedEvents: tags[RelatedReplaceableEvent.tagName]?.map(RelatedEvent.fromTag).toList(),
      groupSubject: tags[GroupSubject.tagName]?.map(GroupSubject.fromTag).singleOrNull,
      quotedEvent:
          tags[QuotedImmutableEvent.tagName]?.map(QuotedImmutableEvent.fromTag).singleOrNull,
      conversationId: tags[ConversationIdentifier.tagName]
              ?.map(ConversationIdentifier.fromTag)
              .singleOrNull
              ?.value ??
          '',
    );
  }

  @override
  FutureOr<EventMessage> toEventMessage(String pubkey) {
    final tags = [
      if (quotedEvent != null) quotedEvent!.toTag(),
      if (groupSubject != null) groupSubject!.toTag(),
      if (relatedEvents != null) ...relatedEvents!.map((event) => event.toTag()),
      if (relatedPubkeys != null) ...relatedPubkeys!.map((pubkey) => pubkey.toTag()),
      if (media.isNotEmpty) ...media.values.map((mediaAttachment) => mediaAttachment.toTag()),
      ReplaceableEventIdentifier(value: messageId).toTag(),
      ConversationIdentifier(value: conversationId).toTag(),
    ];

    final createdAt = DateTime.now();

    final kind14EventId = EventMessage.calculateEventId(
      tags: tags,
      content: content,
      publicKey: pubkey,
      createdAt: createdAt,
      kind: ReplaceablePrivateDirectMessageEntity.kind,
    );

    return EventMessage(
      sig: null,
      tags: tags,
      pubkey: pubkey,
      content: content,
      id: kind14EventId,
      createdAt: createdAt,
      kind: ReplaceablePrivateDirectMessageEntity.kind,
    );
  }
}
