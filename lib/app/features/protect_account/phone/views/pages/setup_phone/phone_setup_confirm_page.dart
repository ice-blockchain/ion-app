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
import 'package:ion/app/features/auth/views/pages/twofa_codes/twofa_code_input.dart';
import 'package:ion/app/features/protect_account/common/two_fa_utils.dart';
import 'package:ion/app/features/protect_account/phone/models/phone_steps.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/security_account_provider.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/utils/validators.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_identity.dart';

class PhoneSetupConfirmPage extends HookConsumerWidget {
  const PhoneSetupConfirmPage({required this.phone, super.key});

  final String phone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;
    final theme = context.theme;
    final formKey = useRef(GlobalKey<FormState>());
    final codeController = useTextEditingController.fromValue(TextEditingValue.empty);

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
                  phone,
                  style: theme.appTextThemes.body,
                ),
                if (isKeyboardVisible) SizedBox(height: 58.0.s),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 22.0.s),
                  child: TextInput(
                    prefixIcon: TextInputIcons(
                      hasRightDivider: true,
                      icons: [Assets.svg.iconFieldPhone.icon()],
                    ),
                    labelText: locale.two_fa_sms,
                    controller: codeController,
                    validator: (String? value) {
                      if (Validators.isEmpty(value)) return '';
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    scrollPadding: EdgeInsets.only(bottom: 200.0.s),
                    keyboardType: TextInputType.number,
                    suffixIcon: SendButton(
                      onRequestCode: () => requestTwoFACode(ref, TwoFAType.sms(phone)),
                    ),
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

                    await validateTwoFACode(ref, TwoFAType.sms(codeController.text));
                    ref.invalidate(securityAccountControllerProvider);

                    if (!context.mounted) {
                      return;
                    }

                    unawaited(
                      PhoneSetupRoute(step: PhoneSetupSteps.success).push<void>(context),
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
