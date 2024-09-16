import 'package:ion_identity_client/src/signer/dtos/dtos.dart';

typedef SignedChallengeResult<F> = ({
  Fido2Assertion assertion,
  UserActionChallenge userActionChallenge,
});
