sealed class RegisterUserResult {}

final class RegisterUserSuccess extends RegisterUserResult {}

sealed class RegisterUserFailure extends RegisterUserResult {}

final class RegistrationCodeExpiredRegisterUserFailure extends RegisterUserFailure {}

final class UserAlreadyExistsRegisterUserFailure extends RegisterUserFailure {}

final class PasskeyValidationRegisterUserFailure extends RegisterUserFailure {}

final class UnknownRegisterUserFailure extends RegisterUserFailure {
  UnknownRegisterUserFailure([
    this.error,
    this.stackTrace,
  ]);

  final Object? error;
  final StackTrace? stackTrace;
}
