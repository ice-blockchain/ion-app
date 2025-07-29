import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';

part 'ion_connect_response.f.freezed.dart';

@freezed
class IonConnectSendResponse<T> with _$IonConnectSendResponse<T> {
  const factory IonConnectSendResponse({
    required T data,
    required IonConnectRelay relay,
  }) = _IonConnectSendResponse<T>;
}
