// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/auth/passkey_prompt_dialog_helper.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/auth/views/pages/recover_user_page/components/recovery_creds_step.dart';
import 'package:ion/app/features/auth/views/pages/recover_user_page/components/twofa_input_step.dart';
import 'package:ion/app/features/auth/views/pages/recover_user_page/components/twofa_options_step.dart';
import 'package:ion/app/features/auth/views/pages/recover_user_page/models/recover_user_step.dart';
import 'package:ion/app/features/protect_account/backup/providers/recover_user_action_notifier.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/selected_two_fa_types_provider.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion_identity_client/ion_identity.dart';

typedef RecoveryCreds = ({String name, String id, String code});

class RecoverUserPage extends HookConsumerWidget {
  const RecoverUserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = useState(RecoverUserStep.recoveryCreds);
    final recoveryCreds = useRef<RecoveryCreds?>(null);
    final twoFAOptions = useRef<Map<TwoFaType, String>?>(null);

    _listenRecoverUserResult(ref, step);

    return ProviderScope(
      overrides: [
        availableTwoFaTypesProvider.overrideWithValue(TwoFaType.values),
      ],
      child: switch (step.value) {
        RecoverUserStep.recoveryCreds => RecoveryCredsStep(
            onContinuePressed: (name, id, code) {
              recoveryCreds.value = (name: name, id: id, code: code);
              _makeRecoverUserRequest(ref, recoveryCreds.value!);
            },
          ),
        RecoverUserStep.twoFAOptions => TwoFAOptionsStep(
            onConfirm: () => step.value = RecoverUserStep.twoFAInput,
          ),
        RecoverUserStep.twoFAInput => TwoFAInputStep(
            recoveryIdentityKeyName: recoveryCreds.value!.name,
            onContinuePressed: (twoFaTypes) {
              twoFAOptions.value = twoFaTypes;
              _makeRecoverUserRequest(ref, recoveryCreds.value!, twoFaTypes);
            },
          ),
      },
    );
  }

  void _makeRecoverUserRequest(
    WidgetRef ref,
    RecoveryCreds recoveryCreds, [
    Map<TwoFaType, String>? twoFaTypes,
  ]) {
    guardPasskeyDialog(
      ref.context,
      recoverUserActionNotifierProvider,
      () {
        ref.read(recoverUserActionNotifierProvider.notifier).recoverUser(
              username: recoveryCreds.name,
              credentialId: recoveryCreds.id,
              recoveryKey: recoveryCreds.code,
              twoFaTypes: twoFaTypes,
            );
      },
    );
  }

  void _listenRecoverUserResult(WidgetRef ref, ValueNotifier<RecoverUserStep> step) {
    ref
      ..listenError(recoverUserActionNotifierProvider, (error) async {
        switch (error) {
          case TwoFARequiredException():
            step.value = RecoverUserStep.twoFAOptions;
          default:
        }
      })
      ..listenSuccess(
        recoverUserActionNotifierProvider,
        (value) {
          value?.whenOrNull(
            success: () => RecoverUserSuccessRoute().push<void>(ref.context),
          );
        },
      );
  }
}
