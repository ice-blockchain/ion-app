// SPDX-License-Identifier: ice License 1.0

sealed class UserActionSignerResult {
  const UserActionSignerResult();
}

class UserActionSignerSuccess extends UserActionSignerResult {
  const UserActionSignerSuccess();
}

sealed class UserActionSignerFailure extends UserActionSignerResult {
  const UserActionSignerFailure();
}

class UserActionSignerInitRequestFailure extends UserActionSignerFailure {
  const UserActionSignerInitRequestFailure([
    this.error,
    this.stackTrace,
  ]);

  final Object? error;
  final StackTrace? stackTrace;
}

class UserActionPasskeySignFailure extends UserActionSignerFailure {
  const UserActionPasskeySignFailure([
    this.error,
    this.stackTrace,
  ]);

  final Object? error;
  final StackTrace? stackTrace;
}

class UserActionSignerSignatureRequestFailure extends UserActionSignerFailure {
  const UserActionSignerSignatureRequestFailure([
    this.error,
    this.stackTrace,
  ]);

  final Object? error;
  final StackTrace? stackTrace;
}

class UserActionSignerCompleteRequestFailure extends UserActionSignerFailure {
  const UserActionSignerCompleteRequestFailure([
    this.error,
    this.stackTrace,
  ]);

  final Object? error;
  final StackTrace? stackTrace;
}
