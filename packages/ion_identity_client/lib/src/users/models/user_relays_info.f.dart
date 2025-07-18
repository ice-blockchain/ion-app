// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/users/models/ion_connect_relay_info.f.dart';

part 'user_relays_info.f.freezed.dart';
part 'user_relays_info.f.g.dart';

@freezed
class UserRelaysInfo with _$UserRelaysInfo {
  const factory UserRelaysInfo({
    required String masterPubKey,
    required List<IonConnectRelayInfo> ionConnectRelays,
  }) = _UserRelaysInfo;

  factory UserRelaysInfo.fromJson(Map<String, dynamic> json) => _$UserRelaysInfoFromJson(json);
}
