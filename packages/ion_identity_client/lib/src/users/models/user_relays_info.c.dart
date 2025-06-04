// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_relays_info.c.freezed.dart';
part 'user_relays_info.c.g.dart';

@freezed
class UserRelaysInfo with _$UserRelaysInfo {
  const factory UserRelaysInfo({
    required String masterPubKey,
    required List<String> ionConnectRelays,
  }) = _UserRelaysInfo;

  factory UserRelaysInfo.fromJson(Map<String, dynamic> json) => _$UserRelaysInfoFromJson(json);
}
