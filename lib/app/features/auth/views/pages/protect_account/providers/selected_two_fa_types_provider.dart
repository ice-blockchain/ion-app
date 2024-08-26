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
    state = state.copyWith(
      selectedValues: {...state.selectedValues, index: newValue},
      availableOptions: _updateAvailableOptions(index, newValue),
    );
  }

  Set<TwoFaType> _updateAvailableOptions(int index, TwoFaType? newValue) {
    final newAvailableOptions = state.availableOptions.toSet();
    final oldValue = state.selectedValues[index];
    if (oldValue != null) newAvailableOptions.add(oldValue);
    if (newValue != null) newAvailableOptions.remove(newValue);
    return newAvailableOptions;
  }

  Set<TwoFaType> getAvailableOptionsForIndex(int index) {
    final selectedValue = state.selectedValues[index];
    return {if (selectedValue != null) selectedValue, ...state.availableOptions};
  }

  Set<TwoFaType> getSelectedOptions() {
    return state.selectedValues.values.whereType<TwoFaType>().toSet();
  }
}
