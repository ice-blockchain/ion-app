final class NetworkFailure {
  const NetworkFailure([
    this.error,
    this.stackTrace,
  ]);

  final Object? error;
  final StackTrace? stackTrace;

  @override
  String toString() => 'NetworFailure(error: $error, stackTrace: $stackTrace)';
}
