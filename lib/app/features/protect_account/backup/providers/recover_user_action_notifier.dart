// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/protect_account/authenticator/data/adapter/twofa_type_adapter.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recover_user_action_notifier.freezed.dart';
part 'recover_user_action_notifier.g.dart';

@freezed
class RecoverUserActionState with _$RecoverUserActionState {
  const factory RecoverUserActionState.initial() = _RecoverUserActionStateInitial;
  const factory RecoverUserActionState.success() = _RecoverUserActionStateSuccess;
}

@riverpod
class RecoverUserActionNotifier extends _$RecoverUserActionNotifier {
  @override
  FutureOr<RecoverUserActionState> build() => const RecoverUserActionState.initial();

  Future<void> recoverUser({
    required String username,
    required String credentialId,
    required String recoveryKey,
    Map<TwoFaType, String>? twoFaTypes,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final ionIdentity = await ref.read(ionIdentityProvider.future);

      final twoFATypes = [
        for (final entry in (twoFaTypes ?? {}).entries)
          TwoFaTypeAdapter(entry.key, entry.value).twoFAType,
      ];

      await ionIdentity(username: username).auth.recoverUser(
            credentialId: credentialId,
            recoveryKey: recoveryKey,
            twoFATypes: twoFATypes,
          );

      return const RecoverUserActionState.success();
    });
  }
}
