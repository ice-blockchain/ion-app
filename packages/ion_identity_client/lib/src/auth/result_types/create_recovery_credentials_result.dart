// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/network/network_failure.dart';
import 'package:ion_identity_client/src/signer/types/user_action_signer_result.dart';

sealed class CreateRecoveryCredentialsResult {
  const CreateRecoveryCredentialsResult();
}

class CreateRecoveryCredentialsSuccess extends CreateRecoveryCredentialsResult {
  const CreateRecoveryCredentialsSuccess({
    required this.identityKeyName,
    required this.recoveryKeyId,
    required this.recoveryCode,
  });

  final String identityKeyName;
  final String recoveryKeyId;
  final String recoveryCode;
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
  CreateCredentialInitCreateRecoveryCredentialsFailure(this.networkFailure) : super(null, null);

  final NetworkFailure networkFailure;
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
