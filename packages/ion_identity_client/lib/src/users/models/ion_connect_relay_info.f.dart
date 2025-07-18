// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ion_connect_relay_info.f.freezed.dart';
part 'ion_connect_relay_info.f.g.dart';

@freezed
class IonConnectRelayInfo with _$IonConnectRelayInfo {
  const factory IonConnectRelayInfo({
    required String url,
    IonConnectRelayType? type,
  }) = _IonConnectRelayInfo;

  factory IonConnectRelayInfo.fromJson(Map<String, dynamic> json) =>
      _$IonConnectRelayInfoFromJson(json);
}

enum IonConnectRelayType {
  read,
  write,
}
