// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/deletable_event.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';

part 'deletion_request.c.freezed.dart';

@Freezed(equal: false)
class DeletionRequestEntity with IonConnectEntity, ImmutableEntity, _$DeletionRequestEntity {
  const factory DeletionRequestEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required DateTime createdAt,
    required DeletionRequest data,
  }) = _DeletionRequestEntity;

  const DeletionRequestEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/09.md
  factory DeletionRequestEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventMessage.id, kind: kind);
    }

    return DeletionRequestEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: DeletionRequest.fromEventMessage(eventMessage),
    );
  }

  static const int kind = 5;
}

@freezed
class DeletionRequest with _$DeletionRequest implements EventSerializable {
  const factory DeletionRequest({required List<DeletableEvent> events}) = _DeletionRequest;

  const DeletionRequest._();

  factory DeletionRequest.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw Exception('Incorrect event kind ${eventMessage.kind}, expected $kind');
    }

    final immutableEvents =
        eventMessage.tags.where((tag) => tag.first == ImmutableEventReference.tagName);
    final immutableEventsKind =
        int.tryParse(eventMessage.tags.singleWhereOrNull((tag) => tag.first == 'k')?[1] ?? '');

    final replaceableEvents =
        eventMessage.tags.where((tag) => tag.first == ReplaceableEventReference.tagName);

    final allEventReferences = [
      ...immutableEvents.map(
        (event) => ImmutableEventReference(
          eventId: event[1],
          kind: immutableEventsKind,
          pubkey: eventMessage.pubkey,
        ),
      ),
      ...replaceableEvents.map(ReplaceableEventReference.fromTag),
    ];

    return DeletionRequest(events: allEventReferences.map(EventToDelete.new).toList());
  }

  /// https://github.com/nostr-protocol/nips/blob/master/09.md
  @override
  FutureOr<EventMessage> toEventMessage(
    EventSigner signer, {
    List<List<String>> tags = const [],
    DateTime? createdAt,
  }) {
    return EventMessage.fromData(
      signer: signer,
      createdAt: createdAt,
      kind: DeletionRequestEntity.kind,
      content: '',
      tags: [
        ...tags,
        for (final event in events) ...event.toTags(),
      ],
    );
  }
}

@freezed
class EventToDelete with _$EventToDelete implements DeletableEvent {
  const factory EventToDelete(EventReference reference) = _EventToDelete;

  const EventToDelete._();

  @override
  List<List<String>> toTags() {
    // Exception for chats as there we have two different event id for the same message
    if (reference is ReplaceableEventReference) {
      return [reference.toTag()];
    }

    final immutableReference = reference as ImmutableEventReference;
    return [
      [ImmutableEventReference.tagName, immutableReference.eventId],
      ['k', immutableReference.kind.toString()],
    ];
  }
}
