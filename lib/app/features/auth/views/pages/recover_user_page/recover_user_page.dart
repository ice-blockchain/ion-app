// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/auth/views/pages/recover_user_page/components/errors/recover_invalid_credentials_error_alert.dart';
import 'package:ion/app/features/auth/views/pages/recover_user_page/components/recovery_creds_step.dart';
import 'package:ion/app/features/auth/views/pages/recover_user_page/models/recover_user_step.dart';
import 'package:ion/app/features/auth/views/pages/recover_user_twofa_page/components/twofa_try_again_page.dart';
import 'package:ion/app/features/auth/views/pages/two_fa/twofa_input_step.dart';
import 'package:ion/app/features/auth/views/pages/two_fa/twofa_options_step.dart';
import 'package:ion/app/features/components/verify_identity/verify_identity_prompt_dialog_helper.dart';
import 'package:ion/app/features/protect_account/backup/providers/recover_user_action_notifier.c.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/selected_two_fa_types_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion_identity_client/ion_identity.dart';

typedef RecoveryCreds = ({String name, String id, String code});

class RecoverUserPage extends HookConsumerWidget {
  const RecoverUserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = useState(RecoverUserStep.recoveryCreds);
    final recoveryCreds = useRef<RecoveryCreds?>(null);
    final twoFAOptions = useRef<Map<TwoFaType, String>?>(null);
    final twoFAOptionsCount = useRef<int>(0);

    _listenInitRecoverResult(
      ref: ref,
      recoveryCreds: recoveryCreds,
      twoFAOptions: twoFAOptions,
      twoFAOptionsCountRef: twoFAOptionsCount,
      step: step,
    );
    _listenCompleteRecoverResult(ref);

    return switch (step.value) {
      RecoverUserStep.recoveryCreds => RecoveryCredsStep(
          onContinuePressed: (name, id, code) {
            recoveryCreds.value = (name: name, id: id, code: code);
            _makeRecoverUserRequest(ref, recoveryCreds.value!);
          },
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
          ),
        ),
      RecoverUserStep.twoFAInput => ProviderScope(
          overrides: [
            availableTwoFaTypesProvider.overrideWithValue(
              (types: TwoFaType.values, count: twoFAOptionsCount.value),
            ),
          ],
          child: TwoFAInputStep(
            identityKeyName: recoveryCreds.value!.name,
            onContinuePressed: (twoFaTypes) {
              twoFAOptions.value = twoFaTypes;
              _makeRecoverUserRequest(ref, recoveryCreds.value!, twoFaTypes);
            },
            onBackPress: () => step.value = RecoverUserStep.twoFAOptions,
          ),
        ),
    };
  }

  void _makeRecoverUserRequest(
    WidgetRef ref,
    RecoveryCreds recoveryCreds, [
    Map<TwoFaType, String>? twoFaTypes,
  ]) {
    ref.read(initUserRecoveryActionNotifierProvider.notifier).initRecovery(
          username: recoveryCreds.name,
          credentialId: recoveryCreds.id,
          twoFaTypes: twoFaTypes,
        );
  }

  void _listenInitRecoverResult({
    required WidgetRef ref,
    required ObjectRef<RecoveryCreds?> recoveryCreds,
    required ObjectRef<Map<TwoFaType, String>?> twoFAOptions,
    required ObjectRef<int> twoFAOptionsCountRef,
    required ValueNotifier<RecoverUserStep> step,
  }) {
    ref
      ..listenError(initUserRecoveryActionNotifierProvider, (error) {
        switch (error) {
          case TwoFARequiredException(:final twoFAOptionsCount):
            twoFAOptionsCountRef.value = twoFAOptionsCount;
            step.value = RecoverUserStep.twoFAOptions;
          case InvalidTwoFaCodeException():
            showSimpleBottomSheet<void>(
              context: ref.context,
              child: const TwoFaTryAgainPage(),
            );
          case InvalidRecoveryCredentialsException():
            showSimpleBottomSheet<void>(
              context: ref.context,
              child: const RecoverInvalidCredentialsErrorAlert(),
            );
          default:
        }
      })
      ..displayErrors(
        initUserRecoveryActionNotifierProvider,
        excludedExceptions: {
          TwoFARequiredException,
          InvalidTwoFaCodeException,
          InvalidRecoveryCredentialsException,
        },
      )
      ..listenSuccess(initUserRecoveryActionNotifierProvider, (value) {
        final challenge = value?.whenOrNull(success: (challenge) => challenge);

        guardPasskeyDialog(
          ref.context,
          (child) => RiverpodVerifyIdentityRequestBuilder(
            provider: completeUserRecoveryActionNotifierProvider,
            requestWithVerifyIdentity: (_) {
              ref.read(completeUserRecoveryActionNotifierProvider.notifier).completeRecovery(
                    username: recoveryCreds.value!.name,
                    credentialId: recoveryCreds.value!.id,
                    recoveryKey: recoveryCreds.value!.code,
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
          success: () => RecoverUserSuccessRoute().push<void>(ref.context),
        );
      },
    );
  }
}
