// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/inputs/text_input/text_input.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/constants/countries.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/protect_account/common/two_fa_utils.dart';
import 'package:ion/app/features/protect_account/phone/models/phone_steps.dart';
import 'package:ion/app/features/protect_account/phone/provider/country_provider.dart';
import 'package:ion/app/features/protect_account/phone/views/components/countries/country_code_input.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/utils/formatters.dart';
import 'package:ion/app/utils/validators.dart';
import 'package:ion_identity_client/ion_identity.dart';

class PhoneSetupInputPage extends HookConsumerWidget {
  const PhoneSetupInputPage({required this.pubkey, super.key});

  final String pubkey;

  static const int minPhoneLength = 5;
  static const int maxPhoneLength = 15;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;
    final formKey = useRef(GlobalKey<FormState>());
    final phoneController = useTextEditingController();

    final country = ref.watch(selectedCountryProvider);

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
                    alwaysShowPrefixIcon: true,
                    prefix: Text('${country.iddCode} '),
                    prefixIcon: CountryCodeInput(
                      country: country,
                      onTap: () async {
                        final data =
                            await SelectCountriesRoute(pubkey: pubkey).push<Country>(context);

                        if (data != null) {
                          ref.read(selectedCountryProvider.notifier).country = data;
                        }
                      },
                    ),
                    labelText: context.i18n.phone_number,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (phone) => validatePhoneNumber(context, country.iddCode, phone),
                    textInputAction: TextInputAction.done,
                    numbersOnly: true,
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

                    final phoneNumber = formatPhoneNumber(
                      country.iddCode,
                      phoneController.text.trim(),
                    );
                    await requestTwoFACode(ref, TwoFAType.sms(phoneNumber));

                    if (!context.mounted) {
                      return;
                    }

                    unawaited(
                      PhoneSetupRoute(
                        pubkey: pubkey,
                        step: PhoneSetupSteps.confirmation,
                        phone: phoneNumber,
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

  String? validatePhoneNumber(BuildContext context, String? countryCode, String? phoneNumber) {
    if (!Validators.isValidPhoneNumber(countryCode, phoneNumber)) {
      return context.i18n.phone_number_invalid;
    }
    return null;
  }
}
