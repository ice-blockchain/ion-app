// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/views/components/recovery_keys_input_container/recovery_keys_input_container.dart';
import 'package:ion/app/features/protect_account/backup/providers/recover_user_action_notifier.dart';

class RecoveryCredsStep extends ConsumerWidget {
  const RecoveryCredsStep({
    required this.onContinuePressed,
    super.key,
  });

  final void Function(String name, String id, String code) onContinuePressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
          initUserRecoveryActionNotifierProvider.select((it) => it.isLoading),
        ) ||
        ref.watch(
          completeUserRecoveryActionNotifierProvider.select((it) => it.isLoading),
        );

    return RecoveryKeysInputContainer(
      isLoading: isLoading,
      validator: (value, property) => value == null || value.isEmpty ? '' : null,
      onContinuePressed: onContinuePressed,
    );
  }
}
