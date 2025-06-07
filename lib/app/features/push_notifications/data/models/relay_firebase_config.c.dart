// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/ion_connect/model/relay_info.c.dart';

part 'relay_firebase_config.c.freezed.dart';
part 'relay_firebase_config.c.g.dart';

@freezed
class RelayFirebaseConfig with _$RelayFirebaseConfig {
  const factory RelayFirebaseConfig({
    required String relayUrl,
    required String relayPubkey,
    required FirebaseConfig firebaseConfig,
  }) = _RelayFirebaseConfig;

  factory RelayFirebaseConfig.fromJson(Map<String, dynamic> json) =>
      _$RelayFirebaseConfigFromJson(json);
}
