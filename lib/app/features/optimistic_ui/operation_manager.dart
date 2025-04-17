import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:ion/app/features/optimistic_ui/operation.c.dart';
import 'package:uuid/uuid.dart';

/// Interface for models that can be used with optimistic operations.
///
/// Any model that wants to use optimistic operations must implement this interface
/// to ensure it has a unique identifier.
abstract class OptimisticModel {
  String get optimisticId;
}

/// Manages optimistic operations for a specific model type.
///
/// This class handles queuing, processing, and reverting operations while maintaining
/// a local state that can be optimistically updated before backend synchronization.
class OptimisticOperationManager<T extends OptimisticModel> {
  OptimisticOperationManager({
    required this.syncCallback,
    required this.onError,
  })  : _stateController = StreamController<List<T>>.broadcast(),
        _currentState = [],
        _pendingOperations = Queue<OptimisticOperation<T>>();

  /// Callback function to synchronize changes with the backend.
  final Future<void> Function(T previousState, T newState) syncCallback;

  /// Callback function that handles errors and determines retry behavior.
  ///
  /// Returns a boolean indicating whether the operation should be retried:
  /// - true: The operation will be retried with exponential backoff
  /// - false: The operation will be marked as failed and local state will be reverted
  final Future<bool> Function(String message, dynamic error) onError;

  final StreamController<List<T>> _stateController;
  final List<T> _currentState;
  final Queue<OptimisticOperation<T>> _pendingOperations;
  bool _isSyncing = false;

  /// Stream of the current state that UI can listen to for updates.
  Stream<List<T>> get stateStream => _stateController.stream;

  /// Initializes the manager with an initial state.
  ///
  /// This method should be called before performing any operations.
  ///
  /// [initialState] - The initial list of models to start with
  void initialize(List<T> initialState) {
    _currentState
      ..clear()
      ..addAll(initialState);
    _stateController.add(_currentState);
  }

  /// Performs an optimistic operation on the model.
  ///
  /// Updates the local state immediately and queues the operation for backend sync.
  ///
  /// Parameters:
  /// - [previousState]: The current state of the model before the operation
  /// - [newState]: The desired state of the model after the operation
  Future<void> performOperation({
    required T previousState,
    required T newState,
  }) async {
    final operation = OptimisticOperation<T>(
      id: const Uuid().v4(),
      type: T.toString(),
      previousState: previousState,
      newState: newState,
      timestamp: DateTime.now(),
    );

    if (!_currentState.any((item) => item.optimisticId == previousState.optimisticId)) {
      _currentState.add(newState);
    } else {
      _applyLocalUpdate(operation);
    }

    _pendingOperations.add(operation);
    _stateController.add(_currentState);

    if (!_isSyncing) {
      await _processNextOperation();
    }
  }

  /// Applies an operation's changes to the local state.
  void _applyLocalUpdate(OptimisticOperation<T> operation) {
    final index = _currentState
        .indexWhere((item) => item.optimisticId == operation.previousState.optimisticId);
    if (index != -1) {
      _currentState[index] = operation.newState;
    }
  }

  /// Processes the next operation in the queue.
  ///
  /// Attempts to sync with backend and handles retry logic based on user-defined criteria.
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
        await Future<void>.delayed(
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

  /// Calculates the exponential backoff time for retries.
  ///
  /// [retryCount] - The number of retry attempts so far
  /// Returns the number of seconds to wait before the next retry
  int _calculateBackoff(int retryCount) {
    return pow(2, retryCount).toInt();
  }

  /// Reverts all operations that depend on a failed operation.
  ///
  /// This ensures data consistency by rolling back any operations that
  /// were based on the failed operation's state.
  void _revertDependentOperations(OptimisticOperation<T> failedOperation) {
    final dependentOps = _pendingOperations
        .where((op) => op.previousState.optimisticId == failedOperation.newState.optimisticId)
        .toList();

    for (final op in dependentOps) {
      _pendingOperations.remove(op);

      final index =
          _currentState.indexWhere((item) => item.optimisticId == op.newState.optimisticId);
      if (index != -1) {
        _currentState[index] = op.previousState;
      }
    }

    final index = _currentState
        .indexWhere((item) => item.optimisticId == failedOperation.newState.optimisticId);

    if (index != -1) {
      _currentState[index] = failedOperation.previousState;
    }

    _stateController.add(_currentState);
  }

  /// Closes the state stream controller.
  ///
  /// Should be called when the manager is no longer needed to prevent memory leaks.
  void dispose() {
    _stateController.close();
  }
}
