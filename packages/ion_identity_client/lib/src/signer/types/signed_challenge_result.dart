// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/signer/dtos/dtos.dart';

typedef SignedUserActionChallengeResult<F> = ({
  Fido2Assertion assertion,
  UserActionChallenge userActionChallenge,
});

typedef SignedUserRegistrationChallengeResult<F> = ({
  Fido2Attestation attestation,
  UserRegistrationChallenge userRegistrationChallenge,
});
