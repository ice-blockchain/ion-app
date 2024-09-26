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

class CreateRecoveryCredentialsFailure extends CreateRecoveryCredentialsResult {
  const CreateRecoveryCredentialsFailure(
    this.error,
    this.stackTrace,
  );

  final Object? error;
  final StackTrace? stackTrace;
}
