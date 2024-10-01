// SPDX-License-Identifier: ice License 1.0

sealed class RegisterUserResult {
  const RegisterUserResult();
}

final class RegisterUserSuccess extends RegisterUserResult {}

sealed class RegisterUserFailure extends RegisterUserResult {
  const RegisterUserFailure();
}

final class UserAlreadyExistsRegisterUserFailure extends RegisterUserFailure {}

final class PasskeyNotAvailableRegisterUserFailure extends RegisterUserFailure {
  const PasskeyNotAvailableRegisterUserFailure();
}

final class PasskeyValidationRegisterUserFailure extends RegisterUserFailure {
  const PasskeyValidationRegisterUserFailure([
    this.error,
    this.stackTrace,
  ]);

  final Object? error;
  final StackTrace? stackTrace;

  @override
  String toString() =>
      'PasskeyValidationRegisterUserFailure(error: $error, stackTrace: $stackTrace)';
}

final class UnknownRegisterUserFailure extends RegisterUserFailure {
  const UnknownRegisterUserFailure([
    this.error,
    this.stackTrace,
  ]);

  final Object? error;
  final StackTrace? stackTrace;

  @override
  String toString() => 'UnknownRegisterUserFailure(error: $error, stackTrace: $stackTrace)';
}
