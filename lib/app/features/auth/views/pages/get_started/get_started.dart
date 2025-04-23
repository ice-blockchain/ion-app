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
import 'package:ion/app/features/components/biometrics/hooks/use_on_suggest_biometrics.dart';
import 'package:ion/app/features/components/passkey/hooks/use_on_suggest_to_create_local_passkey_creds.dart';
import 'package:ion/app/features/components/passkey/no_local_passkey_creds_popup.dart';
import 'package:ion/app/features/components/verify_identity/verify_identity_prompt_dialog_helper.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/selected_two_fa_types_provider.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
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

    ref.displayErrors(
      loginActionNotifierProvider,
      excludedExceptions: {
        TwoFARequiredException,
        NoLocalPasskeyCredsFoundIONIdentityException,
      },
    );

    final onSuggestToCreatePasskeyCreds = useOnSuggestToCreateLocalPasskeyCreds(ref);
    final onSuggestToAddBiometrics = useOnSuggestToAddBiometrics(ref);

    return switch (step.value) {
      GetStartedPageStep.getStarted => GetStartedStep(
          onLogin: (username) async {
            usernameRef.value = username;
            await ref.read(loginActionNotifierProvider.notifier).verifyUserLoginFlow(
                  keyName: username,
                );
            final loginState = ref.watch(loginActionNotifierProvider);
            if (loginState.hasError) {
              if (loginState.error is TwoFARequiredException) {
                final e = loginState.error! as TwoFARequiredException;
                twoFAOptionsCount.value = e.twoFAOptionsCount;
                step.value = GetStartedPageStep.twoFAOptions;
              }
            } else {
              final loginPassword = await _showSignInDialog(
                ref,
                usernameRef.value,
                true,
                twoFAOptions.value,
              );
              final loginState = ref.read(loginActionNotifierProvider);
              if (loginState.hasError) {
                if (context.mounted &&
                    loginState.error is NoLocalPasskeyCredsFoundIONIdentityException) {
                  final proceed = await showSimpleBottomSheet<bool>(
                    context: context,
                    child: const NoLocalPasskeyCredsPopup(),
                  );
                  if (context.mounted && proceed != null && proceed) {
                    await _showSignInDialog(
                      ref,
                      usernameRef.value,
                      false,
                      twoFAOptions.value,
                    );
                    await onSuggestToCreatePasskeyCreds(username);
                  }
                }
              } else if (loginPassword != null) {
                await onSuggestToAddBiometrics(
                  username: username,
                  password: loginPassword,
                );
              }
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
            onContinuePressed: (twoFaTypes) async {
              twoFAOptions.value = twoFaTypes;
              final loginPassword = await _showSignInDialog(
                ref,
                usernameRef.value,
                false,
                twoFAOptions.value,
              );
              if (loginPassword != null) {
                await onSuggestToAddBiometrics(
                  username: usernameRef.value,
                  password: loginPassword,
                );
              }
            },
          ),
        ),
    };
  }

  Future<String?> _showSignInDialog(
    WidgetRef ref,
    String identityKeyName,
    bool localCredsOnly, [
    Map<TwoFaType, String>? twoFaTypes,
  ]) async {
    String? loginPassword;
    await guardPasskeyDialog(
      ref.context,
      identityKeyName: identityKeyName,
      (child) => RiverpodVerifyIdentityRequestBuilder(
        provider: loginActionNotifierProvider,
        identityKeyName: identityKeyName,
        requestWithVerifyIdentity: (OnVerifyIdentity<AssertionRequestData> onVerifyIdentity) {
          ref.read(loginActionNotifierProvider.notifier).signIn(
                keyName: identityKeyName,
                onVerifyIdentity: ({
                  required onPasskeyFlow,
                  required onPasswordFlow,
                  required onBiometricsFlow,
                }) =>
                    onVerifyIdentity(
                  onPasskeyFlow: onPasskeyFlow,
                  onBiometricsFlow: onBiometricsFlow,
                  onPasswordFlow: ({required String password}) {
                    loginPassword = password;
                    return onPasswordFlow(password: password);
                  },
                ),
                twoFaTypes: twoFaTypes,
                localCredsOnly: localCredsOnly,
              );
        },
        child: child,
      ),
    );
    return loginPassword;
  }
}
