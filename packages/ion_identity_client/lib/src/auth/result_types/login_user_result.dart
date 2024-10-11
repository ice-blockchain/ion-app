// SPDX-License-Identifier: ice License 1.0

sealed class LoginUserResult {
  const LoginUserResult();
}

final class LoginUserSuccess extends LoginUserResult {}

sealed class LoginUserFailure extends LoginUserResult {
  const LoginUserFailure();
}

final class PasskeyNotAvailableLoginUserFailure extends LoginUserFailure {
  const PasskeyNotAvailableLoginUserFailure();

  @override
  String toString() => 'Passkey not available';
}

final class PasskeyValidationLoginUserFailure extends LoginUserFailure {
  const PasskeyValidationLoginUserFailure([
    this.error,
    this.stackTrace,
  ]);

  final Object? error;
  final StackTrace? stackTrace;

  @override
  String toString() => 'Passkey validation failed: $error';
}

final class InvalidCodeLoginUserFailure extends LoginUserFailure {
  const InvalidCodeLoginUserFailure();

  @override
  String toString() => 'Invalid code';
}

final class NoCredentialsLoginUserFailure extends LoginUserFailure {
  const NoCredentialsLoginUserFailure();

  @override
  String toString() => 'No credentials found for this user';
}

final class AccountDeactivatedLoginUserFailure extends LoginUserFailure {
  const AccountDeactivatedLoginUserFailure();

  @override
  String toString() => 'Account has been deactivated';
}

final class UnknownLoginUserFailure extends LoginUserFailure {
  const UnknownLoginUserFailure([
    this.error,
    this.stackTrace,
  ]);

  final Object? error;
  final StackTrace? stackTrace;
}
