// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';

part 'events_metadata.c.freezed.dart';

@freezed
class EventsMetadata with _$EventsMetadata implements EventSerializable {
  const factory EventsMetadata({
    required List<EventReference> eventReferences,
    required EventMessage metadata,
  }) = _EventsMetadata;

  const EventsMetadata._();

  /// https://github.com/ice-blockchain/subzero/blob/master/.ion-connect-protocol/ICIP-01.md#special-ephemeral-event-for-embedding-other-non-ephemeral-events
  @override
  FutureOr<EventMessage> toEventMessage(
    EventSigner signer, {
    List<List<String>> tags = const [],
    int? createdAt,
  }) {
    return EventMessage.fromData(
      signer: signer,
      createdAt: createdAt,
      kind: kind,
      content: jsonEncode(metadata.toJson().last),
      tags: [
        ...tags,
        ...eventReferences.map((eventReference) => eventReference.toTag()),
      ],
    );
  }

  static const int kind = 21750;
}
