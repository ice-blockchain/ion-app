// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/auth/dtos/register_complete_wallet.dart';
import 'package:ion_identity_client/src/core/types/request_defaults.dart';
import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/dtos/fido_2_attestation.dart';

class SignedChallenge {
  SignedChallenge({
    required this.firstFactorCredential,
    this.wallets = RequestDefaults.registerCompleteWallets,
  });

  factory SignedChallenge.fromJson(JsonObject json) {
    return SignedChallenge(
      firstFactorCredential: Fido2Attestation.fromJson(json['firstFactorCredential'] as JsonObject),
    );
  }

  final Fido2Attestation firstFactorCredential;
  final List<RegisterCompleteWallet> wallets;

  JsonObject toJson() {
    return {
      'firstFactorCredential': firstFactorCredential.toJson(),
      'wallets': wallets.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() =>
      'SignedChallenge(firstFactorCredential: $firstFactorCredential, wallets: $wallets)';
}
