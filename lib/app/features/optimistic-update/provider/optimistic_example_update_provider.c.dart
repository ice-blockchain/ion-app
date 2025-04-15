import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/optimistic-update/controller/optimistic_update_controller.c.dart';
import 'package:ion/app/features/optimistic-update/ui/optimistic_update_example_view.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'optimistic_example_update_provider.c.g.dart';

/// Riverpod provider for OptimisticUpdateController<ExampleEntity>.
@riverpod
OptimisticUpdateController<ExampleEntity> optimisticExampleUpdateController(
  Ref ref, {
  required Future<void> Function(ExampleEntity, ExampleEntity) syncCallback,
  required Future<bool> Function(String, dynamic) onError,
}) =>
    OptimisticUpdateController<ExampleEntity>(
      syncCallback: syncCallback,
      onError: onError,
    );
