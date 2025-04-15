import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:ion/app/features/optimistic-update/model/optimistic_model.dart';
import 'package:ion/app/features/optimistic-update/model/optimistic_operation.c.dart';

/// Controller for managing optimistic operations for a specific model type.
class OptimisticUpdateController<T extends OptimisticModel> {
  OptimisticUpdateController({
    required this.syncCallback,
    required this.onError,
  });
  final Future<void> Function(T previousState, T newState) syncCallback;
  final Future<bool> Function(String message, dynamic error) onError;

  final StreamController<List<T>> _stateController = StreamController<List<T>>.broadcast();
  final List<T> _currentState = [];
  final Queue<OptimisticOperation<T>> _pendingOperations = Queue<OptimisticOperation<T>>();
  bool _isSyncing = false;

  /// Stream of the current state for UI updates.
  Stream<List<T>> get stateStream => _stateController.stream;

  /// Initializes the controller with an initial state.
  void initialize(List<T> initialState) {
    _currentState
      ..clear()
      ..addAll(initialState);
    _stateController.add(List.unmodifiable(_currentState));
  }

  /// Performs an optimistic operation.
  Future<void> performOperation({
    required T previousState,
    required T newState,
  }) async {
    final operation = OptimisticOperation<T>(
      id: UniqueKey().toString(),
      type: T.toString(),
      previousState: previousState,
      newState: newState,
      timestamp: DateTime.now(),
    );

    if (!_currentState.any((item) => item.id == previousState.id)) {
      _currentState.add(newState);
    } else {
      _applyLocalUpdate(operation);
    }

    _pendingOperations.add(operation);
    _stateController.add(List.unmodifiable(_currentState));

    if (!_isSyncing) {
      await _processNextOperation();
    }
  }

  void _applyLocalUpdate(OptimisticOperation<T> operation) {
    final index = _currentState.indexWhere((item) => item.id == operation.previousState.id);
    if (index != -1) {
      _currentState[index] = operation.newState;
    }
  }

  Future<void> _processNextOperation() async {
    if (_pendingOperations.isEmpty || _isSyncing) return;
    _isSyncing = true;
    var operation = _pendingOperations.first;
    try {
      operation = operation.copyWith(
        status: OperationStatus.processing,
        retryCount: operation.retryCount + 1,
      );
      await syncCallback(operation.previousState, operation.newState);
      operation = operation.copyWith(status: OperationStatus.completed);
      _pendingOperations.removeFirst();
      _isSyncing = false;
    } catch (e) {
      _isSyncing = false;
      final shouldRetry = await onError('Failed to sync Operation ${operation.id}', e);
      if (shouldRetry && operation.retryCount < 3) {
        await Future.delayed(
          Duration(seconds: _calculateBackoff(operation.retryCount)),
          _processNextOperation,
        );
      } else {
        operation = operation.copyWith(status: OperationStatus.failed);
        _revertDependentOperations(operation);
      }
    }
    await _processNextOperation();
  }

  int _calculateBackoff(int retryCount) => pow(2, retryCount).toInt();

  void _revertDependentOperations(OptimisticOperation<T> failedOperation) {
    final dependentOps = _pendingOperations
        .where((op) => op.previousState.id == failedOperation.newState.id)
        .toList();
    for (final op in dependentOps) {
      _pendingOperations.remove(op);
      final index = _currentState.indexWhere((item) => item.id == op.newState.id);
      if (index != -1) {
        _currentState[index] = op.previousState;
      }
    }
    final index = _currentState.indexWhere((item) => item.id == failedOperation.newState.id);
    if (index != -1) {
      _currentState[index] = failedOperation.previousState;
    }
    _stateController.add(List.unmodifiable(_currentState));
  }

  /// Disposes the controller and closes streams.
  void dispose() {
    _stateController.close();
  }
}
