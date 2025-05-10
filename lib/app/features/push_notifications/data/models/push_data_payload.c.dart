import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_parser.c.dart';

part 'push_data_payload.c.freezed.dart';
part 'push_data_payload.c.g.dart';

//TODO: what fields are optional? what to do with imageUrl
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

IonConnectEntity _entityFromEventJson(Map<String, dynamic> json) {
  return EventParser().parse(EventMessage.fromPayloadJson(json));
}

List<IonConnectEntity> _entityListFromEventListJson(List<dynamic> json) {
  return json.map((eventJson) => _entityFromEventJson(eventJson as Map<String, dynamic>)).toList();
}
