// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/auth/views/pages/recover_user_page/models/recover_user_step.dart';
import 'package:ion/app/features/auth/views/pages/restore_from_cloud/components/recover_from_cloud_verify_step.dart';
import 'package:ion/app/features/auth/views/pages/two_fa/twofa_input_step.dart';
import 'package:ion/app/features/auth/views/pages/two_fa/twofa_options_step.dart';
import 'package:ion/app/features/components/verify_identity/verify_identity_prompt_dialog_helper.dart';
import 'package:ion/app/features/protect_account/backup/providers/recover_user_action_notifier.c.dart';
import 'package:ion/app/features/protect_account/backup/providers/recovery_key_cloud_backup_delete_notifier.c.dart';
import 'package:ion/app/features/protect_account/backup/providers/recovery_key_cloud_backup_restore_notifier.c.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/selected_two_fa_types_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_identity.dart';

class RestoreFromCloudPage extends HookConsumerWidget {
  const RestoreFromCloudPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = useState(RecoverUserStep.recoveryCreds);
    final twoFAOptions = useRef<Map<TwoFaType, String>?>(null);
    final twoFAOptionsCount = useRef<int>(0);

    ref.displayErrors(recoveryKeyCloudBackupRestoreNotifierProvider);
    _listenInitRecoverResult(
      ref: ref,
      twoFAOptions: twoFAOptions,
      twoFAOptionsCountRef: twoFAOptionsCount,
      step: step,
    );
    _listenCompleteRecoverResult(ref);

    return switch (step.value) {
      RecoverUserStep.recoveryCreds => RestoreFromCloudVerifyStep(
          onContinue: (identityKeyName, password) {
            _restoreKey(context, ref, identityKeyName: identityKeyName, password: password);
          },
          isLoading: ref.watch(
                recoveryKeyCloudBackupRestoreNotifierProvider.select((it) => it.isLoading),
              ) ||
              ref.watch(initUserRecoveryActionNotifierProvider.select((it) => it.isLoading)) ||
              ref.watch(completeUserRecoveryActionNotifierProvider.select((it) => it.isLoading)),
        ),
      RecoverUserStep.twoFAOptions => ProviderScope(
          overrides: [
            availableTwoFaTypesProvider.overrideWithValue(
              (types: TwoFaType.values, count: twoFAOptionsCount.value),
            ),
          ],
          child: TwoFAOptionsStep(
            twoFAOptionsCount: twoFAOptionsCount.value,
            onConfirm: () => step.value = RecoverUserStep.twoFAInput,
            onBackPress: () => step.value = RecoverUserStep.recoveryCreds,
            titleIcon: Assets.svg.iconLoginRestorecloud.icon(size: 36.0.s),
          ),
        ),
      RecoverUserStep.twoFAInput => ProviderScope(
          overrides: [
            availableTwoFaTypesProvider.overrideWithValue(
              (types: TwoFaType.values, count: twoFAOptionsCount.value),
            ),
          ],
          child: TwoFAInputStep(
            identityKeyName: ref
                .watch(recoveryKeyCloudBackupRestoreNotifierProvider)
                .valueOrNull!
                .identityKeyName,
            onContinuePressed: (twoFaTypes) {
              twoFAOptions.value = twoFaTypes;
              _makeRecoverUserRequest(ref, twoFaTypes);
            },
            onBackPress: () => step.value = RecoverUserStep.twoFAOptions,
            isLoading: ref.watch(
                  initUserRecoveryActionNotifierProvider.select((it) => it.isLoading),
                ) ||
                ref.watch(completeUserRecoveryActionNotifierProvider.select((it) => it.isLoading)),
            titleIcon: Assets.svg.iconLoginRestorecloud.icon(size: 36.0.s),
          ),
        ),
    };
  }

  Future<void> _restoreKey(
    BuildContext context,
    WidgetRef ref, {
    required String identityKeyName,
    required String password,
  }) async {
    await ref
        .watch(recoveryKeyCloudBackupRestoreNotifierProvider.notifier)
        .restore(identityKeyName: identityKeyName, password: password);
    final recoveryCredentialsProvider = ref.read(recoveryKeyCloudBackupRestoreNotifierProvider);
    if (!recoveryCredentialsProvider.hasError && recoveryCredentialsProvider.valueOrNull == null) {
      throw Exception('No credentials');
    } else if (recoveryCredentialsProvider.hasValue) {
      _makeRecoverUserRequest(ref);
    }
  }

  void _makeRecoverUserRequest(
    WidgetRef ref, [
    Map<TwoFaType, String>? twoFaTypes,
  ]) {
    final recoveryCredentials = ref.read(recoveryKeyCloudBackupRestoreNotifierProvider).valueOrNull;
    ref.read(initUserRecoveryActionNotifierProvider.notifier).initRecovery(
          username: recoveryCredentials!.identityKeyName,
          credentialId: recoveryCredentials.recoveryKeyId,
          twoFaTypes: twoFaTypes,
        );
  }

  void _listenInitRecoverResult({
    required WidgetRef ref,
    required ObjectRef<Map<TwoFaType, String>?> twoFAOptions,
    required ObjectRef<int> twoFAOptionsCountRef,
    required ValueNotifier<RecoverUserStep> step,
  }) {
    ref
      ..listenError(initUserRecoveryActionNotifierProvider, (error) {
        if (error is TwoFARequiredException) {
          twoFAOptionsCountRef.value = error.twoFAOptionsCount;
          step.value = RecoverUserStep.twoFAOptions;
        }
      })
      ..displayErrors(
        initUserRecoveryActionNotifierProvider,
        excludedExceptions: {
          TwoFARequiredException,
        },
      )
      ..listenSuccess(initUserRecoveryActionNotifierProvider, (value) {
        final challenge = value?.whenOrNull(success: (challenge) => challenge);

        guardPasskeyDialog(
          ref.context,
          (child) => RiverpodVerifyIdentityRequestBuilder(
            provider: completeUserRecoveryActionNotifierProvider,
            requestWithVerifyIdentity: (_) {
              final recoveryCredentials =
                  ref.read(recoveryKeyCloudBackupRestoreNotifierProvider).valueOrNull;
              ref.read(completeUserRecoveryActionNotifierProvider.notifier).completeRecovery(
                    username: recoveryCredentials!.identityKeyName,
                    credentialId: recoveryCredentials.recoveryKeyId,
                    recoveryKey: recoveryCredentials.recoveryCode,
                    challenge: challenge!,
                  );
            },
            child: child,
          ),
        );
      });
  }

  void _listenCompleteRecoverResult(WidgetRef ref) {
    ref.listenSuccess(
      completeUserRecoveryActionNotifierProvider,
      (value) {
        value?.whenOrNull(
          success: () {
            final recoveryCredentials =
                ref.read(recoveryKeyCloudBackupRestoreNotifierProvider).valueOrNull;
            ref.read(recoveryKeyCloudBackupDeleteNotifierProvider.notifier).remove(
                  identityKeyName: recoveryCredentials!.identityKeyName,
                );
            RecoverUserSuccessRoute().push<void>(ref.context);
          },
        );
      },
    );
  }
}
