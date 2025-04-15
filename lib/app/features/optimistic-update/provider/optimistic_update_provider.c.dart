import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/optimistic-update/controller/optimistic_update_controller.c.dart';
import 'package:ion/app/features/optimistic-update/model/optimistic_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'optimistic_update_provider.c.g.dart';

/// Riverpod provider for OptimisticUpdateController.
@Riverpod(keepAlive: true)
OptimisticUpdateController<T> optimisticUpdateController<T extends OptimisticModel>(
  Ref<T> ref, {
  required Future<void> Function(T previousState, T newState) syncCallback,
  required Future<bool> Function(String message, dynamic error) onError,
}) =>
    OptimisticUpdateController<T>(
      syncCallback: syncCallback,
      onError: onError,
    );
