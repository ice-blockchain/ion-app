// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_identity.freezed.dart';

@freezed
class UserIdentity with _$UserIdentity {
  const factory UserIdentity({
    required List<String> ionConnectRelays,
    required List<String> ionConnectIndexerRelays,
    required String? masterPubkey,
  }) = _UserIdentity;
}
