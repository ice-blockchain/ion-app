// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
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
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final ionIdentity = await ref.read(ionIdentityProvider.future);

      await ionIdentity(username: username)
          .auth
          .recoverUser(credentialId: credentialId, recoveryKey: recoveryKey);

      return const RecoverUserActionState.success();
    });
  }
}
