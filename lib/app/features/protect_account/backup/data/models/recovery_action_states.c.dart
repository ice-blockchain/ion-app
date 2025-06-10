// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/ion_identity.dart';

part 'recovery_action_states.c.freezed.dart';

@freezed
class InitUserRecoveryActionState with _$InitUserRecoveryActionState {
  const factory InitUserRecoveryActionState.initial() = _InitUserRecoveryActionStateInitial;
  const factory InitUserRecoveryActionState.success(UserRegistrationChallenge challenge) =
      _InitUserRecoveryActionStateSuccess;
}

@freezed
class CompleteUserRecoveryActionState with _$CompleteUserRecoveryActionState {
  const factory CompleteUserRecoveryActionState.initial() = _CompleteUserRecoveryActionStateInitial;
  const factory CompleteUserRecoveryActionState.success() = _CompleteUserRecoveryActionStateSuccess;
}
