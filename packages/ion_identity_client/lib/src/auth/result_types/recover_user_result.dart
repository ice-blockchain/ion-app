sealed class RecoverUserResult {
  const RecoverUserResult();
}

class RecoverUserSuccess extends RecoverUserResult {
  const RecoverUserSuccess();
}

class RecoverUserFailure extends RecoverUserResult {
  const RecoverUserFailure(this.error, this.stackTrace);

  final Object? error;
  final StackTrace? stackTrace;
}
