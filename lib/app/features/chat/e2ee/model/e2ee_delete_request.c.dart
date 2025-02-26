// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';

part 'e2ee_delete_request.c.freezed.dart';

@freezed
class E2eeDeleteRequest with _$E2eeDeleteRequest implements EventSerializable {
  const factory E2eeDeleteRequest({
    List<EventToDelete>? events,
    List<ConversationToDelete>? conversations,
  }) = _E2eeDeleteRequest;

  const E2eeDeleteRequest._();

  /// https://github.com/nostr-protocol/nips/blob/master/09.md
  @override
  FutureOr<EventMessage> toEventMessage(
    EventSigner signer, {
    List<List<String>> tags = const [],
    DateTime? createdAt,
  }) {
    final eventsTags = events?.expand((e) => e.toTags()) ?? [];
    final conversationsTags = conversations?.expand((c) => c.toTags()) ?? [];

    return EventMessage.fromData(
      signer: signer,
      createdAt: createdAt,
      kind: kind,
      content: '',
      tags: [
        ...tags,
        ...eventsTags,
        ...conversationsTags,
      ],
    );
  }

  static const int kind = 5;
}

@freezed
class EventToDelete with _$EventToDelete {
  const factory EventToDelete({
    required String eventId,
    required int kind,
  }) = _EventToDelete;

  const EventToDelete._();

  List<List<String>> toTags() {
    return [
      ['e', eventId],
      ['k', kind.toString()],
    ];
  }
}

@freezed
class ConversationToDelete with _$ConversationToDelete {
  const factory ConversationToDelete(String conversationId) = _ConversationToDelete;

  const ConversationToDelete._();

  List<List<String>> toTags() {
    return [
      ['h', conversationId],
    ];
  }
}
