// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/who_can_reply_settings_option.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/entity_editing_ended_at.c.dart';
import 'package:ion/app/features/ion_connect/model/entity_expiration.c.dart';
import 'package:ion/app/features/ion_connect/model/entity_media_data.dart';
import 'package:ion/app/features/ion_connect/model/entity_published_at.c.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/event_setting.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/model/quoted_modifiable_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_hashtag.c.dart';
import 'package:ion/app/features/ion_connect/model/related_pubkey.c.dart';
import 'package:ion/app/features/ion_connect/model/replaceable_event_identifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/services/text_parser/model/text_match.c.dart';
import 'package:ion/app/services/text_parser/model/text_matcher.dart';
import 'package:ion/app/services/text_parser/text_parser.dart';

part 'modifiable_post_data.c.freezed.dart';

@Freezed(equal: false)
class ModifiablePostEntity
    with _$ModifiablePostEntity, IonConnectEntity
    implements CacheableEntity {
  const factory ModifiablePostEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required DateTime createdAt,
    required ModifiablePostData data,
  }) = _ModifiablePostEntity;

  const ModifiablePostEntity._();

  /// Kind 30175 is a addressable version of kind 1
  /// https://github.com/ice-blockchain/subzero/blob/master/.ion-connect-protocol/ICIP-01.md
  factory ModifiablePostEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventId: eventMessage.id, kind: kind);
    }

    return ModifiablePostEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: ModifiablePostData.fromEventMessage(eventMessage),
    );
  }

  @override
  String get cacheKey => cacheKeyBuilder(replaceableEventId: data.replaceableEventId.value);

  static String cacheKeyBuilder({required String replaceableEventId}) => replaceableEventId;

  static const kind = 30175;
}

@freezed
class ModifiablePostData
    with _$ModifiablePostData, EntityMediaDataMixin
    implements EventSerializable {
  const factory ModifiablePostData({
    required List<TextMatch> content,
    required Map<String, MediaAttachment> media,
    required ReplaceableEventIdentifier replaceableEventId,
    required EntityPublishedAt publishedAt,
    EntityEditingEndedAt? editingEndedAt,
    EntityExpiration? expiration,
    QuotedModifiableEvent? quotedEvent,
    List<RelatedEvent>? relatedEvents,
    List<RelatedPubkey>? relatedPubkeys,
    List<RelatedHashtag>? relatedHashtags,
    List<EventSetting>? settings,
  }) = _ModifiablePostData;

  factory ModifiablePostData.fromEventMessage(EventMessage eventMessage) {
    final parsedContent = TextParser.allMatchers().parse(eventMessage.content);

    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);

    return ModifiablePostData(
      content: parsedContent,
      media: EntityMediaDataMixin.buildMedia(tags[MediaAttachment.tagName], parsedContent),
      replaceableEventId:
          ReplaceableEventIdentifier.fromTag(tags[ReplaceableEventIdentifier.tagName]!.first),
      publishedAt: EntityPublishedAt.fromTag(tags[EntityPublishedAt.tagName]!.first),
      editingEndedAt: tags[EntityEditingEndedAt.tagName] != null
          ? EntityEditingEndedAt.fromTag(tags[EntityEditingEndedAt.tagName]!.first)
          : null,
      expiration: tags[EntityExpiration.tagName] != null
          ? EntityExpiration.fromTag(tags[EntityExpiration.tagName]!.first)
          : null,
      quotedEvent: tags[QuotedModifiableEvent.tagName] != null
          ? QuotedModifiableEvent.fromTag(tags[QuotedModifiableEvent.tagName]!.first)
          : null,
      relatedEvents: tags[RelatedEvent.tagName]?.map(RelatedEvent.fromTag).toList(),
      relatedPubkeys: tags[RelatedPubkey.tagName]?.map(RelatedPubkey.fromTag).toList(),
      relatedHashtags: tags[RelatedHashtag.tagName]?.map(RelatedHashtag.fromTag).toList(),
      settings: tags[EventSetting.settingTagName]?.map(EventSetting.fromTag).toList(),
    );
  }

  factory ModifiablePostData.fromRawContent(String content) {
    final parsedContent = TextParser.allMatchers().parse(content);

    final hashtags = parsedContent
        .where((match) => match.matcher is HashtagMatcher)
        .map((match) => RelatedHashtag(value: match.text))
        .toList();

    return ModifiablePostData(
      content: parsedContent,
      relatedHashtags: hashtags,
      replaceableEventId: ReplaceableEventIdentifier.generate(),
      publishedAt: EntityPublishedAt(value: DateTime.now()),
      media: {},
    );
  }

  const ModifiablePostData._();

  @override
  FutureOr<EventMessage> toEventMessage(
    EventSigner signer, {
    List<List<String>> tags = const [],
    DateTime? createdAt,
  }) {
    return EventMessage.fromData(
      signer: signer,
      createdAt: createdAt,
      kind: ModifiablePostEntity.kind,
      content: content.map((match) => match.text).join(),
      tags: [
        ...tags,
        replaceableEventId.toTag(),
        publishedAt.toTag(),
        if (editingEndedAt != null) editingEndedAt!.toTag(),
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

  WhoCanReplySettingsOption? get whoCanReplySetting {
    final whoCanReplySetting =
        settings?.firstWhereOrNull((setting) => setting is WhoCanReplyEventSetting)
            as WhoCanReplyEventSetting?;
    return whoCanReplySetting?.values.firstOrNull;
  }

  @override
  String toString() {
    return 'ModifiablePostData(${content.map((match) => match.text).join()})';
  }
}
