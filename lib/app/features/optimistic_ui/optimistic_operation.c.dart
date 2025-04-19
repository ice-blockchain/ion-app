// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/optimistic_ui/optimistic_model.dart';

part 'optimistic_operation.c.freezed.dart';

enum OperationStatus { pending, processing, completed, failed }

/// Universal operation record for optimistic UI updates.
///
/// Stores the previous and optimistic states, operation type, status, and retry count.
/// Used by the OptimisticOperationManager to manage and synchronize optimistic changes.
@freezed
class OptimisticOperation<T extends OptimisticModel> with _$OptimisticOperation<T> {
  const factory OptimisticOperation({
    required String id,
    required String type,
    required T previousState,
    required T optimisticState,
    @Default(OperationStatus.pending) OperationStatus status,
    @Default(0) int retryCount,
  }) = _OptimisticOperation;
}
