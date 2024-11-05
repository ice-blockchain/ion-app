// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/auth/views/pages/twofa_codes/twofa_code_input.dart';
import 'package:ion/app/features/protect_account/email/data/model/email_steps.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/security_account_provider.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.dart';
import 'package:ion_identity_client/ion_identity.dart';

class EmailSetupConfirmPage extends HookConsumerWidget {
  const EmailSetupConfirmPage({required this.email, super.key});

  final String email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;
    final theme = context.theme;
    final formKey = useRef(GlobalKey<FormState>());
    final emailController = useTextEditingController.fromValue(TextEditingValue.empty);

    return Form(
      key: formKey.value,
      child: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return ScreenSideOffset.large(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 8.0.s),
                Text(
                  email,
                  style: theme.appTextThemes.body,
                ),
                if (isKeyboardVisible) SizedBox(height: 58.0.s),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 22.0.s),
                  child: TwoFaCodeInput(
                    controller: emailController,
                    twoFaType: TwoFaType.email,
                    onRequestCode: () => _requestTwoFACode(ref, emailController.text),
                  ),
                ),
                const Spacer(),
                Button(
                  mainAxisSize: MainAxisSize.max,
                  label: Text(locale.button_confirm),
                  onPressed: () async {
                    final isFormValid = formKey.value.currentState?.validate() ?? false;
                    if (!isFormValid) {
                      return;
                    }

                    await _validateTwoFACode(ref, emailController.text);
                    final _ = await ref.refresh(securityAccountControllerProvider.future);

                    if (!context.mounted) {
                      return;
                    }

                    unawaited(
                      EmailSetupRoute(step: EmailSetupSteps.success).push<void>(context),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _validateTwoFACode(WidgetRef ref, String code) async {
    final currentUser = ref.read(currentIdentityKeyNameSelectorProvider);
    if (currentUser == null) {
      return;
    }

    final ionIdentity = await ref.read(ionIdentityProvider.future);

    await ionIdentity(username: currentUser).auth.verifyTwoFA(TwoFAType.email(code));
  }

  Future<void> _requestTwoFACode(WidgetRef ref, String email) async {
    final currentUser = ref.read(currentIdentityKeyNameSelectorProvider);
    if (currentUser == null) {
      return;
    }

    final ionIdentity = await ref.read(ionIdentityProvider.future);

    await ionIdentity(username: currentUser)
        .auth
        .requestTwoFACode(twoFAType: TwoFAType.email(email));
  }
}
