// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/entity_data_with_media_content.dart';
import 'package:ion/app/features/ion_connect/model/entity_data_with_settings.dart';
import 'package:ion/app/features/ion_connect/model/entity_expiration.c.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/event_setting.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/model/quoted_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event_marker.dart';
import 'package:ion/app/features/ion_connect/model/related_hashtag.c.dart';
import 'package:ion/app/features/ion_connect/model/related_pubkey.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/services/text_parser/model/text_match.c.dart';
import 'package:ion/app/services/text_parser/text_parser.dart';

part 'post_data.c.freezed.dart';

@Freezed(equal: false)
class PostEntity with _$PostEntity, IonConnectEntity, ImmutableEntity, CacheableEntity {
  const factory PostEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required DateTime createdAt,
    required PostData data,
  }) = _PostEntity;

  const PostEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/01.md
  factory PostEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventMessage.id, kind: kind);
    }

    return PostEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: PostData.fromEventMessage(eventMessage),
    );
  }

  static const kind = 1;
}

@freezed
class PostData
    with _$PostData, EntityDataWithMediaContent, EntityDataWithSettings
    implements EventSerializable {
  const factory PostData({
    required List<TextMatch> content,
    required Map<String, MediaAttachment> media,
    EntityExpiration? expiration,
    QuotedEvent? quotedEvent,
    List<RelatedEvent>? relatedEvents,
    List<RelatedPubkey>? relatedPubkeys,
    List<RelatedHashtag>? relatedHashtags,
    List<EventSetting>? settings,
  }) = _PostData;

  factory PostData.fromEventMessage(EventMessage eventMessage) {
    final parsedContent = TextParser.allMatchers().parse(eventMessage.content);

    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);

    return PostData(
      content: parsedContent,
      media: EntityDataWithMediaContent.buildMedia(tags[MediaAttachment.tagName], parsedContent),
      expiration: tags[EntityExpiration.tagName] != null
          ? EntityExpiration.fromTag(tags[EntityExpiration.tagName]!.first)
          : null,
      quotedEvent: tags[QuotedEvent.tagName] != null
          ? QuotedEvent.fromTag(tags[QuotedEvent.tagName]!.first)
          : null,
      relatedEvents: tags[RelatedEvent.tagName]?.map(RelatedEvent.fromTag).toList(),
      relatedPubkeys: tags[RelatedPubkey.tagName]?.map(RelatedPubkey.fromTag).toList(),
      relatedHashtags: tags[RelatedHashtag.tagName]?.map(RelatedHashtag.fromTag).toList(),
      settings: tags[EventSetting.settingTagName]?.map(EventSetting.fromTag).toList(),
    );
  }

  const PostData._();

  @override
  FutureOr<EventMessage> toEventMessage(
    EventSigner signer, {
    List<List<String>> tags = const [],
    DateTime? createdAt,
  }) {
    return EventMessage.fromData(
      signer: signer,
      createdAt: createdAt,
      kind: PostEntity.kind,
      content: content.map((match) => match.text).join(),
      tags: [
        ...tags,
        if (expiration != null) expiration!.toTag(),
        if (quotedEvent != null) quotedEvent!.toTag(),
        if (relatedPubkeys != null) ...relatedPubkeys!.map((pubkey) => pubkey.toTag()),
        if (relatedHashtags != null) ...relatedHashtags!.map((hashtag) => hashtag.toTag()),
        if (relatedEvents != null) ...relatedEvents!.map((event) => event.toTag()),
        if (media.isNotEmpty) ...media.values.map((mediaAttachment) => mediaAttachment.toTag()),
        if (settings != null) ...settings!.map((setting) => setting.toTag()),
      ],
    );
  }

  @override
  String toString() {
    return 'PostData(${content.map((match) => match.text).join()})';
  }

  RelatedEvent? get parentEvent {
    if (relatedEvents == null) return null;

    RelatedEvent? rootReplyId;
    RelatedEvent? replyId;
    for (final relatedEvent in relatedEvents!) {
      if (relatedEvent.marker == RelatedEventMarker.reply) {
        replyId = relatedEvent;
        break;
      } else if (relatedEvent.marker == RelatedEventMarker.root) {
        rootReplyId = relatedEvent;
      }
    }
    return replyId ?? rootReplyId;
  }
}
