import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/constants/countries.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/phone/components/country_code_input.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/phone/models/phone_steps.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/utils/validators.dart';

class PhoneSetupInputPage extends HookWidget {
  const PhoneSetupInputPage({super.key});

  static const int minPhoneLength = 5;
  static const int maxPhoneLength = 10;

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;
    final formKey = useRef(GlobalKey<FormState>());
    final phoneController = useTextEditingController();
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();

    final country = useState(countries[1]);

    return Form(
      key: formKey.value,
      child: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return ScreenSideOffset.large(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isKeyboardVisible) SizedBox(height: 58.0.s),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0.s),
                  child: TextInput(
                    alwaysShowPrefixIcon: true,
                    prefix: Text('${country.value.iddCode} '),
                    prefixIcon: CountryCodeInput(
                      country: country.value,
                      onTap: () async {
                        final data = await SelectCountriesRoute().push<Country>(context);

                        if (data != null) country.value = data;
                      },
                    ),
                    labelText: context.i18n.phone_number,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) => validatePhoneNumber(context, value),
                    textInputAction: TextInputAction.done,
                    numbersOnly: true,
                  ),
                ),
                Spacer(),
                Button(
                  mainAxisSize: MainAxisSize.max,
                  label: Text(locale.button_next),
                  onPressed: () {
                    if (formKey.value.currentState?.validate() == true) {
                      hideKeyboardAndCallOnce(
                        callback: () {
                          final fullPhoneNumber =
                              '${country.value.iddCode}${phoneController.text.trim()}';
                          PhoneSetupRoute(
                            step: PhoneSetupSteps.confirmation,
                            phone: fullPhoneNumber,
                          ).push<void>(context);
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

  String? validatePhoneNumber(BuildContext context, String? phoneNumber) {
    if (Validators.isInvalidLength(phoneNumber,
        minLength: PhoneSetupInputPage.minPhoneLength,
        maxLength: PhoneSetupInputPage.maxPhoneLength)) {
      return context.i18n.phone_number_invalid;
    }
    return null;
  }
}
