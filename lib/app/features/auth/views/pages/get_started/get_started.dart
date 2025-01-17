// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/login_action_notifier.c.dart';
import 'package:ion/app/features/auth/views/pages/get_started/get_started_step.dart';
import 'package:ion/app/features/auth/views/pages/two_fa/twofa_input_step.dart';
import 'package:ion/app/features/auth/views/pages/two_fa/twofa_options_step.dart';
import 'package:ion/app/features/components/verify_identity/verify_identity_prompt_dialog_helper.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/selected_two_fa_types_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';

enum GetStartedPageStep {
  getStarted,
  twoFAOptions,
  twoFAInput,
}

class GetStartedPage extends HookConsumerWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = useState(GetStartedPageStep.getStarted);
    final twoFAOptions = useRef<Map<TwoFaType, String>?>(null);
    final twoFAOptionsCount = useRef<int>(0);
    final usernameRef = useRef<String>('');

    final authState = ref.watch(authProvider);
    final loginActionState = ref.watch(loginActionNotifierProvider);

    ref.displayErrors(loginActionNotifierProvider, excludedExceptions: {TwoFARequiredException});

    return switch (step.value) {
      GetStartedPageStep.getStarted => GetStartedStep(
          onLogin: (username) async {
            usernameRef.value = username;
            await ref.read(loginActionNotifierProvider.notifier).verifyUserLoginFlow(
                  keyName: username,
                );
            final loginState = ref.read(loginActionNotifierProvider);
            if (loginState.hasError && loginState.error is TwoFARequiredException) {
              final e = loginState.error! as TwoFARequiredException;
              twoFAOptionsCount.value = e.twoFAOptionsCount;
              step.value = GetStartedPageStep.twoFAOptions;
            } else {
              await _showSignInDialog(
                ref,
                usernameRef.value,
                twoFAOptions.value,
              );
            }
          },
        ),
      GetStartedPageStep.twoFAOptions => ProviderScope(
          overrides: [
            availableTwoFaTypesProvider.overrideWithValue(
              (types: TwoFaType.values, count: twoFAOptionsCount.value),
            ),
          ],
          child: TwoFAOptionsStep(
            twoFAOptionsCount: twoFAOptionsCount.value,
            onConfirm: () => step.value = GetStartedPageStep.twoFAInput,
            onBackPress: () => step.value = GetStartedPageStep.getStarted,
          ),
        ),
      GetStartedPageStep.twoFAInput => ProviderScope(
          overrides: [
            availableTwoFaTypesProvider.overrideWithValue(
              (types: TwoFaType.values, count: twoFAOptionsCount.value),
            ),
          ],
          child: TwoFAInputStep(
            identityKeyName: usernameRef.value,
            isLoading:
                loginActionState.isLoading || (authState.valueOrNull?.isAuthenticated).falseOrValue,
            onBackPress: () => step.value = GetStartedPageStep.twoFAOptions,
            onContinuePressed: (twoFaTypes) {
              twoFAOptions.value = twoFaTypes;
              _showSignInDialog(
                ref,
                usernameRef.value,
                twoFAOptions.value,
              );
            },
          ),
        ),
    };
  }

  Future<void> _showSignInDialog(
    WidgetRef ref,
    String identityKeyName, [
    Map<TwoFaType, String>? twoFaTypes,
  ]) {
    return guardPasskeyDialog(
      ref.context,
      identityKeyName: identityKeyName,
      (child) => RiverpodVerifyIdentityRequestBuilder(
        provider: loginActionNotifierProvider,
        identityKeyName: identityKeyName,
        requestWithVerifyIdentity: (OnVerifyIdentity<AssertionRequestData> onVerifyIdentity) {
          ref.read(loginActionNotifierProvider.notifier).signIn(
                keyName: identityKeyName,
                onVerifyIdentity: onVerifyIdentity,
                twoFaTypes: twoFaTypes,
              );
        },
        child: child,
      ),
    );
  }
}
