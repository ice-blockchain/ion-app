// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/security_account_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_two_fa_types_provider.freezed.dart';
part 'selected_two_fa_types_provider.g.dart';

@freezed
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
    final securityMethods = ref.watch(securityAccountControllerProvider).requireValue;
    final optionsAmount = securityMethods.enabledTypes.length;

    return AuthenticatorDeleteState(
      optionsAmount: optionsAmount,
      availableOptions: securityMethods.enabledTypes.toSet(),
      selectedValues: List.generate(optionsAmount, (_) => null),
    );
  }

  void updateSelectedTwoFaOption(int index, TwoFaType? newValue) {
    final oldValue = state.selectedValues[index];
    final newSelectedValues = List<TwoFaType?>.from(state.selectedValues)..[index] = newValue;

    var newAvailableOptions = state.availableOptions;
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
Set<TwoFaType> selectedTwoFaOptions(Ref ref) {
  final state = ref.watch(authenticatorDeleteOptionsProvider);
  return state.selectedValues.whereType<TwoFaType>().toSet();
}
