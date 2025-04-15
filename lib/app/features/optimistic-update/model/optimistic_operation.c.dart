import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ion/app/features/optimistic-update/model/optimistic_model.dart';

part 'optimistic_operation.c.freezed.dart';

/// Represents a generic optimistic operation for any model type.
@freezed
class OptimisticOperation<T extends OptimisticModel> with _$OptimisticOperation<T> {
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

/// Status of an optimistic operation.
enum OperationStatus {
  pending,
  processing,
  completed,
  failed,
}
