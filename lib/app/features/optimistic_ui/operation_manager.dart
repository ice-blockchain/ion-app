// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:ion/app/features/optimistic_ui/optimistic_model.dart';
import 'package:ion/app/features/optimistic_ui/optimistic_operation.c.dart';
import 'package:uuid/uuid.dart';

typedef SyncCallback<T extends OptimisticModel> = Future<T> Function(
  T previous,
  T optimistic,
);

typedef ErrorCallback = Future<bool> Function(String message, Object error);

/// Manages optimistic UI operations and state synchronization with the backend.
///
/// Handles optimistic updates, retries, rollback, and error management for a list of [OptimisticModel]s.
/// Emits state changes via a broadcast stream for UI consumption.
class OptimisticOperationManager<T extends OptimisticModel> {
  OptimisticOperationManager({
    required this.syncCallback,
    required this.onError,
    this.maxRetries = 3,
  })  : _state = [],
        _pending = Queue<OptimisticOperation<T>>();

  final SyncCallback<T> syncCallback;
  final ErrorCallback onError;
  final int maxRetries;

  final _controller = StreamController<List<T>>.broadcast();
  Stream<List<T>> get stream => _controller.stream;

  final List<T> _state;
  final Queue<OptimisticOperation<T>> _pending;
  bool _busy = false;

  void initialize(List<T> initial) {
    _state
      ..clear()
      ..addAll(initial);
    _controller.add(List.unmodifiable(_state));
  }

  /// Adds a new optimistic operation and triggers processing if idle.
  Future<void> perform({
    required T previous,
    required T optimistic,
  }) async {
    // Remove any pending operations for the same id to avoid conflicts.
    _pending.removeWhere(
      (operation) => operation.previousState.optimisticId == previous.optimisticId,
    );

    final optimisticOperation = OptimisticOperation<T>(
      id: const Uuid().v4(),
      type: T.toString(),
      previousState: previous,
      optimisticState: optimistic,
    );

    _applyLocal(optimisticOperation);
    _pending.add(optimisticOperation);

    if (!_busy) await _next();
  }

  void dispose() => _controller.close();

  /// Applies the optimistic state locally and emits the updated state to the stream.
  void _applyLocal(OptimisticOperation<T> optimisticOperation) {
    final stateIndex = _state.indexWhere(
      (model) => model.optimisticId == optimisticOperation.previousState.optimisticId,
    );
    if (stateIndex == -1) {
      _state.add(optimisticOperation.optimisticState);
    } else {
      _state[stateIndex] = optimisticOperation.optimisticState;
    }
    _controller.add(List.unmodifiable(_state));
  }

  /// Schedules and processes the next optimistic operation in the queue.
  /// Handles retries, backend sync, and triggers rollback on failure.
  Future<void> _next() async {
    if (_pending.isEmpty) return;
    _busy = true;

    var optimisticOperation = _pending.removeFirst();

    try {
      optimisticOperation = optimisticOperation.copyWith(status: OperationStatus.processing);
      final backendState = await syncCallback(
        optimisticOperation.previousState,
        optimisticOperation.optimisticState,
      );

      // If backend state differs from UI, schedule a follow-up sync.
      final stateIndex =
          _state.indexWhere((model) => model.optimisticId == backendState.optimisticId);
      final isStateMatching = stateIndex != -1 && _state[stateIndex].equals(backendState);

      if (!isStateMatching) {
        await perform(previous: _state[stateIndex], optimistic: backendState);
      }
    } catch (error) {
      // If error occurs, decide whether to retry or rollback.
      final shouldRetry = await onError('Sync failed (${optimisticOperation.id})', error);
      if (shouldRetry && optimisticOperation.retryCount < maxRetries) {
        final retryDelay = Duration(seconds: pow(2, optimisticOperation.retryCount).toInt());
        await Future<void>.delayed(retryDelay);
        // Re-add operation with incremented retry count.
        _pending.addFirst(
          optimisticOperation.copyWith(
            retryCount: optimisticOperation.retryCount + 1,
            status: OperationStatus.pending,
          ),
        );
      } else {
        _rollback(optimisticOperation);
      }
    } finally {
      _busy = false;
      await _next(); // Continue processing the queue.
    }
  }

  /// Rolls back the optimistic state to the previous state in case of failure.
  void _rollback(OptimisticOperation<T> optimisticOperation) {
    final stateIndex = _state.indexWhere(
      (model) => model.optimisticId == optimisticOperation.optimisticState.optimisticId,
    );
    if (stateIndex != -1) {
      _state[stateIndex] = optimisticOperation.previousState;
      _controller.add(List.unmodifiable(_state));
    }
  }
}
