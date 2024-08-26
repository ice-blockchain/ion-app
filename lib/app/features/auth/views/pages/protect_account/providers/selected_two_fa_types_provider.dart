import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/auth/data/models/twofa_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_two_fa_types_provider.freezed.dart';
part 'selected_two_fa_types_provider.g.dart';

@Freezed(copyWith: true)
class AuthenticatorDeleteState with _$AuthenticatorDeleteState {
  factory AuthenticatorDeleteState({
    required int optionsAmount,
    required Set<TwoFaType> availableOptions,
    required Map<int, TwoFaType?> selectedValues,
  }) = _AuthenticatorDeleteState;
}

@riverpod
class AuthenticatorDeleteOptions extends _$AuthenticatorDeleteOptions {
  @override
  AuthenticatorDeleteState build() {
    final optionsAmount = Random().nextInt(2) + 1;
    return AuthenticatorDeleteState(
      optionsAmount: optionsAmount,
      availableOptions: TwoFaType.values.toSet(),
      selectedValues: {for (int i = 0; i < optionsAmount; i++) i: null},
    );
  }

  void updateOption(int index, TwoFaType? newValue) {
    final oldValue = state.selectedValues[index];
    final newSelectedValues = {...state.selectedValues, index: newValue};
    final newAvailableOptions = _updateAvailableOptions(oldValue, newValue);

    state = state.copyWith(
      selectedValues: newSelectedValues,
      availableOptions: newAvailableOptions,
    );
  }

  Set<TwoFaType> _updateAvailableOptions(TwoFaType? oldValue, TwoFaType? newValue) {
    final newAvailableOptions = state.availableOptions.toSet();
    if (newValue != null) {
      newAvailableOptions.remove(newValue);
    }
    if (oldValue != null) {
      newAvailableOptions.add(oldValue);
    }
    return newAvailableOptions;
  }
}

@riverpod
Set<TwoFaType> selectedTwoFaOptions(SelectedTwoFaOptionsRef ref) {
  final state = ref.watch(authenticatorDeleteOptionsProvider);
  return state.selectedValues.values.whereType<TwoFaType>().toSet();
}
