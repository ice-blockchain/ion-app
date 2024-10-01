// SPDX-License-Identifier: ice License 1.0

import 'package:fpdart/fpdart.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';
import 'package:ion_identity_client/src/signer/types/signed_challenge_result.dart';

extension PasskeySignerExtensions on PasskeysSigner {
  TaskEither<F, SignedChallengeResult<F>> signChallenge<F>(
    TaskEither<F, UserActionChallenge> challengeTask,
    F Function(Object, StackTrace) onFailure,
  ) {
    return challengeTask.flatMap(
      (userActionChallenge) => TaskEither<F, Fido2Assertion>.tryCatch(
        () => sign(userActionChallenge),
        onFailure,
      ).flatMap(
        (assertion) => TaskEither.of(
          (
            userActionChallenge: userActionChallenge,
            assertion: assertion,
          ),
        ),
      ),
    );
  }
}
