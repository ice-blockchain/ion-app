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
      (op) => op.previousState.optimisticId == previous.optimisticId,
    );

    final op = OptimisticOperation<T>(
      id: const Uuid().v4(),
      type: T.toString(),
      previousState: previous,
      optimisticState: optimistic,
    );

    _applyLocal(op);
    _pending.add(op);

    if (!_busy) await _next();
  }

  void dispose() => _controller.close();

  void _applyLocal(OptimisticOperation<T> op) {
    final idx = _state.indexWhere((e) => e.optimisticId == op.previousState.optimisticId);
    if (idx == -1) {
      _state.add(op.optimisticState);
    } else {
      _state[idx] = op.optimisticState;
    }
    _controller.add(List.unmodifiable(_state));
  }

  Future<void> _next() async {
    if (_pending.isEmpty) return;
    _busy = true;

    var op = _pending.removeFirst();

    try {
      op = op.copyWith(status: OperationStatus.processing);
      final actual = await syncCallback(op.previousState, op.optimisticState);

      // compare UI state
      final idx = _state.indexWhere((e) => e.optimisticId == actual.optimisticId);
      final matches = idx != -1 && _state[idx].equals(actual);

      if (!matches) {
        await perform(previous: _state[idx], optimistic: actual);
      }
    } catch (e) {
      final retry = await onError('Sync failed (${op.id})', e);
      if (retry && op.retryCount < maxRetries) {
        final wait = Duration(seconds: pow(2, op.retryCount).toInt());
        await Future<void>.delayed(wait);
        // add only one copy with incremented counter
        _pending.addFirst(
          op.copyWith(
            retryCount: op.retryCount + 1,
            status: OperationStatus.pending,
          ),
        );
      } else {
        _rollback(op);
      }
    } finally {
      _busy = false;
      await _next(); // process the next element
    }
  }

  void _rollback(OptimisticOperation<T> op) {
    final idx = _state.indexWhere((e) => e.optimisticId == op.optimisticState.optimisticId);
    if (idx != -1) {
      _state[idx] = op.previousState;
      _controller.add(List.unmodifiable(_state));
    }
  }
}
