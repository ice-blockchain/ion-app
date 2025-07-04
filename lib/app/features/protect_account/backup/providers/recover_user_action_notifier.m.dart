// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/protect_account/authenticator/data/adapter/twofa_type_adapter.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.r.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recover_user_action_notifier.m.freezed.dart';
part 'recover_user_action_notifier.m.g.dart';

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

@riverpod
class InitUserRecoveryActionNotifier extends _$InitUserRecoveryActionNotifier {
  @override
  FutureOr<InitUserRecoveryActionState> build() => const InitUserRecoveryActionState.initial();

  Future<void> initRecovery({
    required String username,
    required String credentialId,
    Map<TwoFaType, String>? twoFaTypes,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final ionIdentity = await ref.read(ionIdentityProvider.future);

      final twoFATypes = [
        for (final entry in (twoFaTypes ?? {}).entries)
          TwoFaTypeAdapter(entry.key, entry.value).twoFAType,
      ];

      try {
        final challenge = await ionIdentity(username: username).auth.initRecovery(
              credentialId: credentialId,
              twoFATypes: twoFATypes,
            );
        return InitUserRecoveryActionState.success(challenge);
      } on PasskeyCancelledException {
        return const InitUserRecoveryActionState.initial();
      }
    });
  }
}

@riverpod
class CompleteUserRecoveryActionNotifier extends _$CompleteUserRecoveryActionNotifier {
  @override
  FutureOr<CompleteUserRecoveryActionState> build() =>
      const CompleteUserRecoveryActionState.initial();

  Future<void> completeRecovery({
    required String username,
    required String credentialId,
    required String recoveryKey,
    required UserRegistrationChallenge challenge,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final ionIdentity = await ref.read(ionIdentityProvider.future);

      await ionIdentity(username: username).auth.completeRecovery(
            challenge: challenge,
            credentialId: credentialId,
            recoveryKey: recoveryKey,
          );

      return const CompleteUserRecoveryActionState.success();
    });
  }
}
