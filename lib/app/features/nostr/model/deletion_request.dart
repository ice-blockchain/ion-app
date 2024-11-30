// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/nostr/model/event_serializable.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'deletion_request.freezed.dart';

@freezed
class DeletionRequest with _$DeletionRequest implements EventSerializable {
  const factory DeletionRequest({
    required List<EventToDelete> events,
  }) = _DeletionRequest;

  const DeletionRequest._();

  /// https://github.com/nostr-protocol/nips/blob/master/09.md
  @override
  EventMessage toEventMessage(EventSigner signer, {List<List<String>> tags = const []}) {
    return EventMessage.fromData(
      signer: signer,
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
