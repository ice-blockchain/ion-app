// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';

typedef SignedUserActionChallengeResult<F> = ({
  AssertionRequestData assertion,
  UserActionChallenge userActionChallenge,
});

typedef SignedUserRegistrationChallengeResult<F> = ({
  CredentialRequestData attestation,
  UserRegistrationChallenge userRegistrationChallenge,
});
