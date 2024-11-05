// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ion/app/components/inputs/text_input/text_input.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/protect_account/common/two_fa_utils.dart';
import 'package:ion/app/features/protect_account/email/data/model/email_steps.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion_identity_client/ion_identity.dart';

class EmailSetupInputPage extends HookConsumerWidget {
  const EmailSetupInputPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;
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
                if (isKeyboardVisible) SizedBox(height: 58.0.s),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0.s),
                  child: TextInput(
                    prefixIcon: TextInputIcons(
                      hasRightDivider: true,
                      icons: [TwoFaType.email.iconAsset.icon()],
                    ),
                    labelText: context.i18n.common_email_address,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => (value?.isEmpty ?? false) ? '' : null,
                    textInputAction: TextInputAction.done,
                    scrollPadding: EdgeInsets.only(bottom: 200.0.s),
                  ),
                ),
                const Spacer(),
                Button(
                  mainAxisSize: MainAxisSize.max,
                  label: Text(locale.button_next),
                  onPressed: () async {
                    final isFormValid = formKey.value.currentState?.validate() ?? false;
                    if (!isFormValid) {
                      return;
                    }

                    await requestTwoFACode(ref, TwoFAType.email(emailController.text));

                    if (!context.mounted) {
                      return;
                    }

                    unawaited(
                      EmailSetupRoute(
                        step: EmailSetupSteps.confirmation,
                        email: emailController.text,
                      ).push<void>(context),
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
}
