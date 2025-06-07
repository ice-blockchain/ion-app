// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/protect_account/secure_account/data/models/select_two_fa_options_state.c.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/security_account_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_two_fa_types_provider.c.g.dart';


@Riverpod(dependencies: [availableTwoFaTypes])
class SelectedTwoFAOptionsNotifier extends _$SelectedTwoFAOptionsNotifier {
  @override
  SelectTwoFAOptionsState build() {
    final availableTwoFATypes = ref.watch(availableTwoFaTypesProvider);
    final optionsAmount = availableTwoFATypes.count;

    return SelectTwoFAOptionsState(
      optionsAmount: optionsAmount,
      availableOptions: availableTwoFATypes.types.toSet(),
      selectedValues: List.generate(optionsAmount, (_) => null),
    );
  }

  void updateSelectedTwoFaOption(int index, TwoFaType? newValue) {
    final newSelectedValues = List<TwoFaType?>.from(state.selectedValues)..[index] = newValue;

    state = state.copyWith(
      selectedValues: newSelectedValues,
    );
  }
}

@Riverpod(dependencies: [SelectedTwoFAOptionsNotifier])
Set<TwoFaType> selectedTwoFaOptions(Ref ref) {
  final state = ref.watch(selectedTwoFAOptionsNotifierProvider);
  return state.selectedValues.whereType<TwoFaType>().toSet();
}


@Riverpod(dependencies: [])
AvailableTwoFATypesState availableTwoFaTypes(Ref ref) =>
    throw UnimplementedError('availableTwoFaTypesProvider must be overridden');

@riverpod
AvailableTwoFATypesState securityMethodsEnabledTypes(Ref ref) {
  final enabledTypes = ref.watch(securityAccountControllerProvider).requireValue.enabledTypes;
  return (types: enabledTypes, count: enabledTypes.length);
}
