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

  Future<void> perform({
    required T previous,
    required T optimistic,
  }) async {
    // coalesce — remove previous operations with the same id
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

      // compare UI state
      final stateIndex =
          _state.indexWhere((model) => model.optimisticId == backendState.optimisticId);
      final isStateMatching = stateIndex != -1 && _state[stateIndex].equals(backendState);

      if (!isStateMatching) {
        await perform(previous: _state[stateIndex], optimistic: backendState);
      }
    } catch (error) {
      final shouldRetry = await onError('Sync failed (${optimisticOperation.id})', error);
      if (shouldRetry && optimisticOperation.retryCount < maxRetries) {
        final retryDelay = Duration(seconds: pow(2, optimisticOperation.retryCount).toInt());
        await Future<void>.delayed(retryDelay);
        // add only one copy with incremented counter
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
      await _next(); // process the next element
    }
  }

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
