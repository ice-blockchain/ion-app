// SPDX-License-Identifier: ice License 1.0

class CreateRecoveryCredentialsSuccess {
  const CreateRecoveryCredentialsSuccess({
    required this.identityKeyName,
    required this.recoveryKeyId,
    required this.recoveryCode,
  });

  final String identityKeyName;
  final String recoveryKeyId;
  final String recoveryCode;
}
