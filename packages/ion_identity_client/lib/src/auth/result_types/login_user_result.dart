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
}

final class PasskeyValidationLoginUserFailure extends LoginUserFailure {
  const PasskeyValidationLoginUserFailure([
    this.error,
    this.stackTrace,
  ]);

  final Object? error;
  final StackTrace? stackTrace;

  @override
  String toString() => 'PasskeyValidationLoginUserFailure(error: $error, stackTrace: $stackTrace)';
}

final class UnknownLoginUserFailure extends LoginUserFailure {
  const UnknownLoginUserFailure([
    this.error,
    this.stackTrace,
  ]);

  final Object? error;
  final StackTrace? stackTrace;
}
