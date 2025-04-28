// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/deletable_event.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';

part 'deletion_request.c.freezed.dart';

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
      kind: kind,
      content: '',
      tags: [
        ...tags,
        for (final event in events) ...event.toTags(),
      ],
    );
  }

  static const int kind = 5;
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
