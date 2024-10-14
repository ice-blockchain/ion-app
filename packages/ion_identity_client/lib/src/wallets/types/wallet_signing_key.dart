// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_signing_key.freezed.dart';
part 'wallet_signing_key.g.dart';

@freezed
class WalletSigningKey with _$WalletSigningKey {
  factory WalletSigningKey({
    required String scheme,
    required String curve,
    required String publicKey,
  }) = _WalletSigningKey;

  factory WalletSigningKey.fromJson(Map<String, dynamic> json) => _$WalletSigningKeyFromJson(json);
}
