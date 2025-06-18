// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/auth/providers/login_action_notifier.c.dart';
import 'package:ion/app/features/auth/views/components/auth_footer/auth_footer.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ion/app/features/auth/views/pages/get_started/components/login_form.dart';
import 'package:ion/app/features/auth/views/pages/get_started/get_started.dart';
import 'package:ion/app/features/components/biometrics/hooks/use_on_suggest_biometrics.dart';
import 'package:ion/app/features/components/passkey/hooks/use_on_suggest_to_create_local_passkey_creds.dart';
import 'package:ion/app/features/components/passkey/no_local_passkey_creds_popup.dart';
import 'package:ion/app/features/user/providers/user_verify_identity_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_identity.dart';

typedef PromptSignInDialogCallback = Future<String?> Function(
  WidgetRef ref, {
  required String identityKeyName,
  required bool localCredsOnly,
  required Map<TwoFaType, String>? twoFaTypes,
});

typedef SuggestBiometricsCallback = Future<void> Function({
  required String password,
  required String username,
});

class SignInStep extends HookConsumerWidget {
  const SignInStep({
    required this.usernameRef,
    required this.twoFAOptions,
    required this.twoFAOptionsCount,
    required this.step,
    required this.showSignInDialog,
    super.key,
  });

  final ObjectRef<String> usernameRef;
  final ObjectRef<Map<TwoFaType, String>?> twoFAOptions;
  final ObjectRef<int> twoFAOptionsCount;
  final ValueNotifier<GetStartedPageStep> step;

  final PromptSignInDialogCallback showSignInDialog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPasskeyAvailable = ref.watch(isPasskeyAvailableProvider).valueOrNull ?? false;

    final onSuggestToCreatePasskeyCreds = useOnSuggestToCreateLocalPasskeyCreds(ref);
    final onSuggestToAddBiometrics = useOnSuggestToAddBiometrics(ref);

    final alreadyAskedRef = useRef(false);

    final loginActionState = ref.watch(loginActionNotifierProvider);

    return SheetContent(
      body: KeyboardDismissOnTap(
        child: AuthScrollContainer(
          showBackButton: false,
          title: context.i18n.get_started_title,
          description: context.i18n.get_started_description,
          icon: const IconAsset(Assets.svgIconLoginIcelogo, size: 44),
          children: [
            ScreenSideOffset.large(
              child: Column(
                children: [
                  SizedBox(height: 56.0.s),
                  LoginForm(
                    onLogin: (username) {
                      usernameRef.value = username;
                      if (username.isEmpty) {
                        _attemptAutoPasskeyLogin(ref, alreadyAskedRef);
                      } else {
                        _handleLoginWithPasswordFallback(
                          ref,
                          username: username,
                          onSuggestToCreatePasskeyCreds: onSuggestToCreatePasskeyCreds,
                          onSuggestToAddBiometrics: onSuggestToAddBiometrics,
                        );
                      }
                    },
                  ),
                  SizedBox(height: 14.0.s),
                  Text(
                    context.i18n.get_started_method_divider,
                    style: context.theme.appTextThemes.caption.copyWith(
                      color: context.theme.appColors.tertararyText,
                    ),
                  ),
                  SizedBox(height: 14.0.s),
                  Button(
                    type: ButtonType.outlined,
                    leadingIcon: IconAssetColored(
                      Assets.svgIconLoginCreateacc,
                      color: context.theme.appColors.secondaryText,
                    ),
                    onPressed: () {
                      if (isPasskeyAvailable) {
                        SignUpPasskeyRoute().push<void>(context);
                      } else {
                        SignUpPasswordRoute().push<void>(context);
                      }
                    },
                    label: Text(context.i18n.button_register),
                    mainAxisSize: MainAxisSize.max,
                  ),
                  SizedBox(height: 16.0.s),
                  Button(
                    labelFlex: 2,
                    type: ButtonType.outlined,
                    leadingIcon: Flexible(
                      child: IconAssetColored(
                        Assets.svgIconRestorekey,
                        color: context.theme.appColors.secondaryText,
                      ),
                    ),
                    disabled: loginActionState.isLoading,
                    onPressed: () => RestoreMenuRoute().push<void>(context),
                    label: Text(
                      context.i18n.get_started_restore_button,
                      maxLines: 2,
                    ),
                    mainAxisSize: MainAxisSize.max,
                    borderColor: Colors.transparent,
                  ),
                  SizedBox(height: 16.0.s),
                  ScreenBottomOffset(child: const AuthFooter()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _attemptAutoPasskeyLogin(WidgetRef ref, ObjectRef<bool> alreadyAskedRef) {
    if (alreadyAskedRef.value) {
      return;
    }
    alreadyAskedRef.value = true;

    ref.read(loginActionNotifierProvider.notifier).signIn(
          keyName: usernameRef.value,
          onVerifyIdentity: ({
            required onPasskeyFlow,
            required onPasswordFlow,
            required onBiometricsFlow,
          }) =>
              onPasskeyFlow(),
          twoFaTypes: twoFAOptions.value,
          localCredsOnly: true,
        );
  }

  /// Attempts to sign in using stored credentials or passkey.
  /// Falls back to password prompt and biometric suggestion if necessary.
  Future<void> _handleLoginWithPasswordFallback(
    WidgetRef ref, {
    required String username,
    required Future<void> Function(String username) onSuggestToCreatePasskeyCreds,
    required SuggestBiometricsCallback onSuggestToAddBiometrics,
  }) async {
    await ref.read(loginActionNotifierProvider.notifier).verifyUserLoginFlow(keyName: username);
    final loginState = ref.read(loginActionNotifierProvider);
    if (loginState.hasError) {
      if (loginState.error is TwoFARequiredException) {
        final e = loginState.error! as TwoFARequiredException;
        twoFAOptionsCount.value = e.twoFAOptionsCount;
        step.value = GetStartedPageStep.twoFAOptions;
      }
    } else {
      final loginPassword = await showSignInDialog(
        ref,
        identityKeyName: usernameRef.value,
        localCredsOnly: true,
        twoFaTypes: twoFAOptions.value,
      );
      final loginState = ref.read(loginActionNotifierProvider);
      if (loginState.hasError) {
        if (ref.context.mounted &&
            loginState.error is NoLocalPasskeyCredsFoundIONIdentityException) {
          final proceed = await showSimpleBottomSheet<bool>(
            context: ref.context,
            child: const NoLocalPasskeyCredsPopup(),
          );
          if (ref.context.mounted && proceed != null && proceed) {
            await showSignInDialog(
              ref,
              identityKeyName: usernameRef.value,
              localCredsOnly: false,
              twoFaTypes: twoFAOptions.value,
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
  }
}
