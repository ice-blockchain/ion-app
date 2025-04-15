import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/optimistic-update/model/optimistic_model.dart';

part 'optimistic_update_state.c.freezed.dart';

/// UI state for optimistic update feature.
@freezed
class OptimisticUpdateState<T extends OptimisticModel> with _$OptimisticUpdateState<T> {
  const factory OptimisticUpdateState({
    @Default([]) List<T> items,
    @Default(false) bool isLoading,
    String? error,
  }) = _OptimisticUpdateState<T>;
}
