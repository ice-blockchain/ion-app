// SPDX-License-Identifier: ice License 1.0

sealed class RegisterUserResult {
  const RegisterUserResult();
}

final class RegisterUserSuccess extends RegisterUserResult {}

sealed class RegisterUserFailure extends RegisterUserResult {
  const RegisterUserFailure();
}

final class UserAlreadyExistsRegisterUserFailure extends RegisterUserFailure {
  @override
  String toString() => 'User already exists';
}

final class RegistrationCodeExpiredRegisterUserFailure extends RegisterUserFailure {
  @override
  String toString() => 'Registration code expired';
}

final class PasskeyNotAvailableRegisterUserFailure extends RegisterUserFailure {
  const PasskeyNotAvailableRegisterUserFailure();

  @override
  String toString() => 'Passkey not available';
}

final class PasskeyValidationRegisterUserFailure extends RegisterUserFailure {
  const PasskeyValidationRegisterUserFailure([
    this.error,
    this.stackTrace,
  ]);

  final Object? error;
  final StackTrace? stackTrace;

  @override
  String toString() => 'Passkey validation failed: $error';
}

final class UnknownRegisterUserFailure extends RegisterUserFailure {
  const UnknownRegisterUserFailure([
    this.error,
    this.stackTrace,
  ]);

  final Object? error;
  final StackTrace? stackTrace;

  @override
  String toString() => 'Unknown error: $error';
}
