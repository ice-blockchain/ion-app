// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/auth/views/pages/twofa_codes/twofa_code_input.dart';
import 'package:ion/app/features/protect_account/email/data/model/email_steps.dart';
import 'package:ion/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ion/app/router/app_routes.dart';

class EmailSetupConfirmPage extends HookConsumerWidget {
  const EmailSetupConfirmPage({required this.email, super.key});

  final String email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;
    final theme = context.theme;
    final formKey = useRef(GlobalKey<FormState>());
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();
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
                  ),
                ),
                const Spacer(),
                Button(
                  mainAxisSize: MainAxisSize.max,
                  label: Text(locale.button_confirm),
                  onPressed: () {
                    if (formKey.value.currentState?.validate() ?? false) {
                      hideKeyboardAndCallOnce(
                        callback: () {
                          ref
                              .read(securityAccountControllerProvider.notifier)
                              .toggleEmail(value: true);
                          EmailSetupRoute(step: EmailSetupSteps.success).push<void>(context);
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
