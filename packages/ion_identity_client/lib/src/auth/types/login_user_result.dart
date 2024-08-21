sealed class LoginUserResult {}

final class LoginUserSuccess extends LoginUserResult {}

sealed class LoginUserFailure extends LoginUserResult {}

final class UserNotFoundLoginUserFailure extends LoginUserFailure {}

final class UserDeactivatedLoginUserFailure extends LoginUserFailure {}

final class WrongCredentialsLoginUserFailure extends LoginUserFailure {}

final class InvalidCodeLoginUserFailure extends LoginUserFailure {}

final class PasskeyValidationLoginUserFailure extends LoginUserFailure {}

final class UnknownLoginUserFailure extends LoginUserFailure {
  UnknownLoginUserFailure([
    this.error,
    this.stackTrace,
  ]);

  final Object? error;
  final StackTrace? stackTrace;
}
