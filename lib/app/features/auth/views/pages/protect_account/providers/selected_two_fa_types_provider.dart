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
    required List<TwoFaType?> selectedValues,
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
      selectedValues: List.generate(optionsAmount, (_) => null),
    );
  }

  void updateSelectedTwoFaOption(int index, TwoFaType? newValue) {
    final oldValue = state.selectedValues[index];
    final newSelectedValues = List<TwoFaType?>.from(state.selectedValues);
    newSelectedValues[index] = newValue;

    Set<TwoFaType> newAvailableOptions = state.availableOptions;
    if (oldValue != null) {
      newAvailableOptions = newAvailableOptions.union({oldValue});
    }
    if (newValue != null) {
      newAvailableOptions = newAvailableOptions.difference({newValue});
    }

    state = state.copyWith(
      selectedValues: newSelectedValues,
      availableOptions: newAvailableOptions,
    );
  }
}

@riverpod
Set<TwoFaType> selectedTwoFaOptions(SelectedTwoFaOptionsRef ref) {
  final state = ref.watch(authenticatorDeleteOptionsProvider);
  return state.selectedValues.whereType<TwoFaType>().toSet();
}
