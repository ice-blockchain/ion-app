// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/auth/dtos/register_complete_wallet.dart';
import 'package:ion_identity_client/src/core/types/request_defaults.dart';
import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/dtos/fido_2_attestation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'signed_challenge.g.dart';

@JsonSerializable()
class SignedChallenge {
  SignedChallenge({
    required this.firstFactorCredential,
    this.wallets = RequestDefaults.registerCompleteWallets,
  });

  factory SignedChallenge.fromJson(JsonObject json) => _$SignedChallengeFromJson(json);

  final Fido2Attestation firstFactorCredential;
  final List<RegisterCompleteWallet> wallets;

  JsonObject toJson() => _$SignedChallengeToJson(this);

  @override
  String toString() =>
      'SignedChallenge(firstFactorCredential: $firstFactorCredential, wallets: $wallets)';
}
