// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/chat/model/related_subject.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/entity_data_with_media_content.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_pubkey.c.dart';
import 'package:ion/app/services/text_parser/model/text_match.c.dart';
import 'package:ion/app/services/text_parser/text_parser.dart';

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

  String get allPubkeysMask => allPubkeys.join(',');

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
    required List<TextMatch> content,
    required Map<String, MediaAttachment> media,
    String? relatedGroupImagePath,
    RelatedSubject? relatedSubject,
    List<RelatedPubkey>? relatedPubkeys,
    List<RelatedEvent>? relatedEvents,
  }) = _PrivateDirectMessageData;

  factory PrivateDirectMessageData.fromEventMessage(EventMessage eventMessage) {
    final parsedContent = TextParser.allMatchers().parse(eventMessage.content);

    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);

    return PrivateDirectMessageData(
      content: parsedContent,
      media: EntityDataWithMediaContent.parseImeta(tags[MediaAttachment.tagName]),
      relatedSubject: tags[RelatedSubject.tagName]?.map(RelatedSubject.fromTag).singleOrNull,
      relatedPubkeys: tags[RelatedPubkey.tagName]?.map(RelatedPubkey.fromTag).toList(),
      relatedEvents: tags[RelatedEvent.tagName]?.map(RelatedEvent.fromTag).toList(),
    );
  }

  factory PrivateDirectMessageData.fromRawContent(String content) {
    final parsedContent = TextParser.allMatchers().parse(content);

    return PrivateDirectMessageData(
      content: parsedContent,
      media: {},
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
