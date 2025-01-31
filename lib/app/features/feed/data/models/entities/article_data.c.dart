// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/color_label.c.dart';
import 'package:ion/app/features/ion_connect/model/entity_published_at.c.dart';
import 'package:ion/app/features/ion_connect/model/entity_settings_data.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/event_setting.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/model/related_hashtag.c.dart';
import 'package:ion/app/features/ion_connect/model/replaceable_event_identifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/services/quill/markdown.dart';

part 'article_data.c.freezed.dart';

const textEditorSingleImageKey = 'text-editor-single-image';

@Freezed(equal: false)
class ArticleEntity
    with _$ArticleEntity, IonConnectEntity, CacheableEntity
    implements ReplaceableEntity {
  const factory ArticleEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required DateTime createdAt,
    required ArticleData data,
  }) = _ArticleEntity;

  const ArticleEntity._();

  factory ArticleEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw Exception('Incorrect event kind ${eventMessage.kind}, expected $kind');
    }

    return ArticleEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: ArticleData.fromEventMessage(eventMessage),
    );
  }

  @override
  ReplaceableEventReference toEventReference() {
    return data.toReplaceableEventReference(masterPubkey);
  }

  static const kind = 30023;
}

@freezed
class ArticleData
    with _$ArticleData, EntitySettingsDataMixin
    implements EventSerializable, ReplaceableEntityData {
  const factory ArticleData({
    required String content,
    required Map<String, MediaAttachment> media,
    required ReplaceableEventIdentifier replaceableEventId,
    required EntityPublishedAt publishedAt,
    String? title,
    String? image,
    String? summary,
    List<RelatedHashtag>? relatedHashtags,
    List<EventSetting>? settings,
    ColorLabel? colorLabel,
  }) = _ArticleData;

  const ArticleData._();

  factory ArticleData.fromEventMessage(EventMessage eventMessage) {
    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);

    final title = tags['title']?.firstOrNull?.elementAtOrNull(1);
    final image = tags['image']?.firstOrNull?.elementAtOrNull(1);
    final summary = tags['summary']?.firstOrNull?.elementAtOrNull(1);
    final mediaAttachments = _buildMedia(tags[MediaAttachment.tagName]);

    return ArticleData(
      content: jsonEncode(markdownToDelta(eventMessage.content).toJson()), //TODO:Delta in content
      media: mediaAttachments,
      title: title,
      image: image,
      summary: summary,
      publishedAt: EntityPublishedAt.fromTag(tags[EntityPublishedAt.tagName]!.first),
      replaceableEventId:
          ReplaceableEventIdentifier.fromTag(tags[ReplaceableEventIdentifier.tagName]!.first),
      relatedHashtags: tags[RelatedHashtag.tagName]?.map(RelatedHashtag.fromTag).toList(),
      settings: tags[EventSetting.settingTagName]?.map(EventSetting.fromTag).toList(),
      colorLabel: ColorLabel.fromTags(tags, eventId: eventMessage.id),
    );
  }

  factory ArticleData.fromData({
    required String content,
    required Map<String, MediaAttachment> media,
    String? title,
    String? image,
    String? summary,
    DateTime? publishedAt,
    List<RelatedHashtag>? relatedHashtags,
    List<EventSetting>? settings,
    String? imageColor,
  }) {
    return ArticleData(
      content: content,
      media: media,
      title: title,
      image: image,
      summary: summary,
      publishedAt: EntityPublishedAt(value: publishedAt ?? DateTime.now()),
      replaceableEventId: ReplaceableEventIdentifier.generate(),
      relatedHashtags: relatedHashtags,
      settings: settings,
      colorLabel: imageColor != null ? ColorLabel(value: imageColor) : null,
    );
  }

  @override
  FutureOr<EventMessage> toEventMessage(
    EventSigner signer, {
    List<List<String>> tags = const [],
    DateTime? createdAt,
  }) {
    return EventMessage.fromData(
      signer: signer,
      createdAt: createdAt,
      kind: ArticleEntity.kind,
      tags: [
        ...tags,
        replaceableEventId.toTag(),
        publishedAt.toTag(),
        if (title != null) ['title', title!],
        if (image != null) ['image', image!],
        if (summary != null) ['summary', summary!],
        if (media.isNotEmpty) ...media.values.map((mediaAttachment) => mediaAttachment.toTag()),
        if (colorLabel != null) colorLabel!.toNamespaceTag(),
        if (colorLabel != null) colorLabel!.toValueTag(),
        if (settings != null) ...settings!.map((setting) => setting.toTag()),
      ],
      content: deltaToMarkdown(
        Delta.fromJson(jsonDecode(content) as List<dynamic>),
      ), //TODO:keep Delta in content
    );
  }

  @override
  ReplaceableEventReference toReplaceableEventReference(String pubkey) {
    return ReplaceableEventReference(
      kind: ArticleEntity.kind,
      pubkey: pubkey,
      dTag: replaceableEventId.value,
    );
  }

  static List<RelatedHashtag> extractTagsFromMarkdown(String content) {
    final operations = jsonDecode(content) as List<dynamic>;
    const insertKey = 'insert';

    return operations
        .whereType<Map<String, dynamic>>()
        .where(
          (operation) =>
              operation.containsKey(insertKey) &&
              operation[insertKey] is String &&
              ((operation[insertKey] as String).startsWith('#') ||
                  (operation[insertKey] as String).startsWith(r'$')),
        )
        .map((operation) {
      final insert = operation[insertKey]! as String;
      return RelatedHashtag(value: insert);
    }).toList();
  }

  static List<String> extractImageIds(QuillController textEditorController) {
    final imageIds = <String>[];
    for (final operation in textEditorController.document.toDelta().operations) {
      final data = operation.data;
      if (data is Map<String, dynamic> && data.containsKey(textEditorSingleImageKey)) {
        imageIds.add(data[textEditorSingleImageKey] as String);
      }
    }
    return imageIds;
  }

  static Map<String, MediaAttachment> _buildMedia(List<List<String>>? mediaTags) {
    if (mediaTags == null) return {};
    return {
      for (final tag in mediaTags)
        if (tag.length > 1) tag[1]: MediaAttachment.fromTag(tag),
    };
  }
}
