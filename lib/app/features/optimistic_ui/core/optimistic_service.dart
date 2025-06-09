// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:ion/app/features/optimistic_ui/core/operation_manager.dart';
import 'package:ion/app/features/optimistic_ui/core/optimistic_intent.dart';
import 'package:ion/app/features/optimistic_ui/core/optimistic_model.dart';

/// Thin wrapper over OptimisticOperationManager
class OptimisticService<T extends OptimisticModel> {
  OptimisticService({required OptimisticOperationManager<T> manager}) : _manager = manager;

  final OptimisticOperationManager<T> _manager;

  Stream<T?> watch(String id) => _manager.stream.map(
        (l) => l.firstWhereOrNull((e) => e.optimisticId == id),
      );

  /// Dispatches an optimistic intent.
  Future<void> dispatch(OptimisticIntent<T> intent, T current) async =>
      _manager.perform(previous: current, optimistic: intent.optimistic(current));

  /// Initializes the manager with initial state.
  Future<void> initialize(FutureOr<List<T>> init) async => _manager.initialize(init);

  Future<void> dispose() async => _manager.dispose();
}
