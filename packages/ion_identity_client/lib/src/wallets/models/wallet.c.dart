// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/wallets/models/wallet_signing_key.c.dart';

part 'wallet.c.freezed.dart';
part 'wallet.c.g.dart';

@freezed
class Wallet with _$Wallet {
  factory Wallet({
    required String id,
    required String network,
    required String status,
    required WalletSigningKey signingKey,
    required String? address,
    required String name,
  }) = _Wallet;

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
}
