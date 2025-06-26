// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/core/types/types.dart';

part 'signed_challenge.f.freezed.dart';
part 'signed_challenge.f.g.dart';

@freezed
class SignedChallenge with _$SignedChallenge {
  const factory SignedChallenge({
    required CredentialRequestData firstFactorCredential,
  }) = _SignedChallenge;

  factory SignedChallenge.fromJson(JsonObject json) => _$SignedChallengeFromJson(json);
}
