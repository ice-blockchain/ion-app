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
}

class CreateRecoveryCredentialsFailure extends CreateRecoveryCredentialsResult {
  const CreateRecoveryCredentialsFailure(
    this.error,
    this.stackTrace,
  );

  final Object? error;
  final StackTrace? stackTrace;
}
