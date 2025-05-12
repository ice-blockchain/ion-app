// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';

part 'ion_connect_push_data_payload.c.freezed.dart';
part 'ion_connect_push_data_payload.c.g.dart';

@Freezed(toJson: false)
class IonConnectPushDataPayload with _$IonConnectPushDataPayload {
  const factory IonConnectPushDataPayload({
    required String title,
    required String body,
    required String? imageUrl,
    @JsonKey(fromJson: _entityFromEventJson) required EventMessage event,
    @JsonKey(name: 'related_events', fromJson: _entityListFromEventListJson)
    required List<EventMessage> relatedEvents,
  }) = _IonConnectPushDataPayload;

  factory IonConnectPushDataPayload.fromJson(Map<String, dynamic> json) =>
      _$IonConnectPushDataPayloadFromJson(json);
}

EventMessage _entityFromEventJson(String stringifiedJson) {
  return EventMessage.fromPayloadJson(jsonDecode(stringifiedJson) as Map<String, dynamic>);
}

List<EventMessage> _entityListFromEventListJson(String stringifiedJson) {
  return (jsonDecode(stringifiedJson) as List<dynamic>)
      .map(
        (eventJson) => EventMessage.fromPayloadJson(eventJson as Map<String, dynamic>),
      )
      .toList();
}
