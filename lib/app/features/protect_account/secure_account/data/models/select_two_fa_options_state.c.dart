// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';

part 'select_two_fa_options_state.c.freezed.dart';

@freezed
class SelectTwoFAOptionsState with _$SelectTwoFAOptionsState {
  factory SelectTwoFAOptionsState({
    required int optionsAmount,
    required Set<TwoFaType> availableOptions,
    required List<TwoFaType?> selectedValues,
  }) = _SelectTwoFAOptionsState;
}

typedef AvailableTwoFATypesState = ({
  List<TwoFaType> types,
  int count,
});
