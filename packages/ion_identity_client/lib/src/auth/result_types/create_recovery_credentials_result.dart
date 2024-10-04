// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/network/network_failure.dart';
import 'package:ion_identity_client/src/signer/types/user_action_signer_result.dart';

abstract class CreateRecoveryCredentialsResult {
  const CreateRecoveryCredentialsResult();
}

class CreateRecoveryCredentialsSuccess extends CreateRecoveryCredentialsResult {
  const CreateRecoveryCredentialsSuccess({
    required this.recoveryName,
    required this.recoveryId,
    required this.recoveryCode,
  });

  final String recoveryName;
  final String recoveryId;
  final String recoveryCode;

  @override
  String toString() {
    return 'CreateRecoveryCredentialsSuccess(recoveryName: $recoveryName, recoveryId: $recoveryId, recoveryCode: $recoveryCode)';
  }
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
