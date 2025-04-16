import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/optimistic-update/operation_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
OptimisticOperationManager optimisticOperationManager(Ref ref) {
  final manager = OptimisticOperationManager(
    syncCallback: (previousState, newState) async {},
    onError: (message, error) async => false,
  );

  ref.onDispose(manager.dispose);

  return manager;
}
