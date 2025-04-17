import 'package:freezed_annotation/freezed_annotation.dart';

part 'operation.c.freezed.dart';

/// Represents a generic optimistic operation that can be performed on any model type.
///
/// An optimistic operation maintains both the previous and next state of an operation,
/// allowing for rollback in case of failure.
@freezed
class OptimisticOperation<T> with _$OptimisticOperation<T> {
  const factory OptimisticOperation({
    required String id,
    required String type,
    required T previousState,
    required T newState,
    required DateTime timestamp,
    @Default(0) int retryCount,
    @Default(OperationStatus.pending) OperationStatus status,
  }) = _OptimisticOperation;
}

/// Represents the current status of an optimistic operation.
enum OperationStatus {
  /// Operation is queued but not yet processed
  pending,

  /// Operation is currently being processed
  processing,

  /// Operation has been successfully completed
  completed,

  /// Operation has failed and will not be retried
  failed
}
