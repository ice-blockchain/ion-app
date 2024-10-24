// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/signer/types/user_action_signer_result.dart';

sealed class CreateRecoveryCredentialsResult {
  const CreateRecoveryCredentialsResult();
}

sealed class CreateRecoveryCredentialsFailure extends CreateRecoveryCredentialsResult {
  const CreateRecoveryCredentialsFailure(
    this.error,
    this.stackTrace,
  );

  final Object? error;
  final StackTrace? stackTrace;
}

class CreateCredentialInitCreateRecoveryCredentialsFailure
    extends CreateRecoveryCredentialsFailure {
  CreateCredentialInitCreateRecoveryCredentialsFailure() : super(null, null);
}

class CreateRecoveryKeyCreateRecoveryCredentialsFailure extends CreateRecoveryCredentialsFailure {
  CreateRecoveryKeyCreateRecoveryCredentialsFailure(super.error, super.stackTrace);
}

class CreateCredentialRequestCreateRecoveryCredentialsFailure
    extends CreateRecoveryCredentialsFailure {
  CreateCredentialRequestCreateRecoveryCredentialsFailure(this.userActionSignerFailure)
      : super(null, null);

  final UserActionSignerFailure userActionSignerFailure;
}
