// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/replaceable_event_identifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';

part 'bookmarks_collection.c.freezed.dart';

@Freezed(equal: false)
class BookmarksCollectionEntity
    with IonConnectEntity, CacheableEntity, ReplaceableEntity, _$BookmarksCollectionEntity {
  const factory BookmarksCollectionEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required DateTime createdAt,
    required BookmarksCollectionData data,
  }) = _BookmarksCollectionEntity;

  const BookmarksCollectionEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/51.md#sets
  factory BookmarksCollectionEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventMessage.id, kind: kind);
    }

    return BookmarksCollectionEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: BookmarksCollectionData.fromEventMessage(eventMessage),
    );
  }

  static const int kind = 30003;
  static const String defaultCollectionDTag = 'homefeed_collection_all';
  static const String collectionsDTag = 'homefeed_collections';
}

@freezed
class BookmarksCollectionData
    with _$BookmarksCollectionData
    implements EventSerializable, ReplaceableEntityData {
  const factory BookmarksCollectionData({
    required String type,
    required List<EventReference> refs,
    @Default('') String title,
    @Default('') String content,
  }) = _BookmarksCollectionData;

  const BookmarksCollectionData._();

  factory BookmarksCollectionData.fromEventMessage(EventMessage eventMessage) {
    final typeName = eventMessage.tags
        .firstWhereOrNull((tag) => tag[0] == ReplaceableEventIdentifier.tagName)?[1];

    if (typeName == null) {
      throw IncorrectEventTagsException(eventId: eventMessage.id);
    }

    final content = eventMessage.content;

    final titleTag =
        eventMessage.tags.firstWhereOrNull((tag) => tag.isNotEmpty && tag.first == 'title');
    final title = titleTag != null && titleTag.length > 1 ? titleTag[1] : '';

    return BookmarksCollectionData(
      content: content,
      refs: eventMessage.tags
          .where(
            (tag) =>
                tag.isNotEmpty &&
                (tag.first == ReplaceableEventReference.tagName ||
                    tag.first == ImmutableEventReference.tagName),
          )
          .map(EventReference.fromTag)
          .toList(),
      type: typeName,
      title: title,
    );
  }

  @override
  FutureOr<EventMessage> toEventMessage(
    EventSigner signer, {
    DateTime? createdAt,
    String content = '',
    List<List<String>> tags = const [],
  }) {
    return EventMessage.fromData(
      signer: signer,
      content: this.content,
      createdAt: createdAt,
      kind: BookmarksCollectionEntity.kind,
      tags: [
        ...tags,
        ReplaceableEventIdentifier(value: type).toTag(),
        ...refs.map((ref) => ref.toTag()),
        ['title', title],
      ],
    );
  }

  @override
  ReplaceableEventReference toReplaceableEventReference(String pubkey) {
    return ReplaceableEventReference(
      pubkey: pubkey,
      dTag: type,
      kind: BookmarksCollectionEntity.kind,
    );
  }
}
