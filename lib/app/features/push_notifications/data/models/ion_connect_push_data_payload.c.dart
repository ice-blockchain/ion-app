import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_parser.c.dart';

part 'ion_connect_push_data_payload.c.freezed.dart';
part 'ion_connect_push_data_payload.c.g.dart';

@Freezed(toJson: false)
class IonConnectPushDataPayload with _$IonConnectPushDataPayload {
  const factory IonConnectPushDataPayload({
    required String title,
    required String body,
    required String? imageUrl,
    @JsonKey(fromJson: _entityFromEventJson) required IonConnectEntity event,
    @JsonKey(name: 'related_events', fromJson: _entityListFromEventListJson)
    required List<IonConnectEntity> relatedEvents,
  }) = _IonConnectPushDataPayload;

  factory IonConnectPushDataPayload.fromJson(Map<String, dynamic> json) =>
      _$IonConnectPushDataPayloadFromJson(json);
}

IonConnectEntity _entityFromEventJson(String stringifiedJson) {
  return EventParser()
      .parse(EventMessage.fromPayloadJson(jsonDecode(stringifiedJson) as Map<String, dynamic>));
}

List<IonConnectEntity> _entityListFromEventListJson(String stringifiedJson) {
  return (jsonDecode(stringifiedJson) as List<dynamic>)
      .map(
        (eventJson) =>
            EventParser().parse(EventMessage.fromPayloadJson(eventJson as Map<String, dynamic>)),
      )
      .toList();
}
