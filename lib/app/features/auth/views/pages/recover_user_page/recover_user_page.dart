// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/auth/views/components/recovery_keys_input_container/recovery_keys_input_container.dart';
import 'package:ice/app/features/auth/views/pages/recover_user_page/components/recover_user_success_state.dart';
import 'package:ice/app/features/protect_account/backup/providers/recover_user_action_notifier.dart';

class RecoverUserPage extends ConsumerWidget {
  const RecoverUserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recoverUserState = ref.watch(recoverUserActionNotifierProvider);

    if (recoverUserState.valueOrNull == null) {
      return RecoveryKeysInputContainer(
        isLoading: recoverUserState.isLoading,
        validator: (value, property) => value == null || value.isEmpty ? '' : null,
        onContinuePressed: (name, id, code) {
          ref.read(recoverUserActionNotifierProvider.notifier).recoverUser(
                username: name,
                credentialId: id,
                recoveryKey: code,
              );
        },
      );
    }

    // TODO: add failure UI state

    return const RecoverUserSuccessState();
  }
}
