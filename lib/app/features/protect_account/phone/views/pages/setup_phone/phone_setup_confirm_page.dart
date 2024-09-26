import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/pages/twofa_codes/twofa_code_input.dart';
import 'package:ice/app/features/protect_account/phone/models/phone_steps.dart';
import 'package:ice/app/features/protect_account/secure_account/providers/security_account_provider.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/utils/validators.dart';
import 'package:ice/generated/assets.gen.dart';

class PhoneSetupConfirmPage extends HookConsumerWidget {
  const PhoneSetupConfirmPage({required this.phone, super.key});

  final String phone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;
    final theme = context.theme;
    final formKey = useRef(GlobalKey<FormState>());
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();
    final phoneController = useTextEditingController.fromValue(TextEditingValue.empty);

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
                    controller: phoneController,
                    validator: (String? value) {
                      if (Validators.isEmpty(value)) return '';
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    scrollPadding: EdgeInsets.only(bottom: 200.0.s),
                    keyboardType: TextInputType.number,
                    suffixIcon: const SendButton(),
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
                              .togglePhone(value: true);
                          PhoneSetupRoute(step: PhoneSetupSteps.success).push<void>(context);
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
