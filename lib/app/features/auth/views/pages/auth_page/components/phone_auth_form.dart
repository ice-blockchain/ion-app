import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/constants/countries.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/components/country_code_input.dart';
import 'package:ice/app/features/auth/views/pages/select_country/select_country_return_data.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/app/router/my_app_routes.dart';
import 'package:ice/app/services/keyboard/keyboard.dart';
import 'package:ice/app/utils/validators.dart';
import 'package:ice/generated/assets.gen.dart';

class PhoneAuthForm extends HookConsumerWidget {
  const PhoneAuthForm({super.key});

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final country = useState(countries[1]);
    final inputController = useTextEditingController();
    final loading = useState(false);
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextInput(
            prefix: Text('${country.value.iddCode} '),
            prefixIcon: CountryCodeInput(
              country: country.value,
              onTap: () async {
                // final data = await IceRoutes.selectCountries
                //     .push<SelectCountryReturnData>(context);
                // if (data != null) {
                //   country.value = data.country;
                // }

                final data = await const SelectCountriesRoute()
                    .push<SelectCountryReturnData>(context);

                if (data != null) {
                  country.value = data.country;
                }
              },
            ),
            labelText: context.i18n.auth_signIn_input_phone_number,
            controller: inputController,
            validator: (String? value) {
              if (Validators.isEmpty(value)) return '';
              return null;
            },
            textInputAction: TextInputAction.done,
            numbersOnly: true,
          ),
          SizedBox(
            height: 16.0.s,
          ),
          Button(
            disabled: loading.value,
            trailingIcon: loading.value
                ? const ButtonLoadingIndicator()
                : Assets.images.icons.iconButtonNext.icon(
                    color: context.theme.appColors.onPrimaryAccent,
                  ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                loading.value = true;
                hideKeyboard(context);
                await Future<void>.delayed(const Duration(seconds: 1));
                loading.value = false;
                hideKeyboardAndCallOnce(
                  // callback: () => IceRoutes.enterCode.push(context),
                  callback: () => const EnterCodeRoute().push<void>(context),
                );
              }
            },
            label: Text(context.i18n.button_continue),
            mainAxisSize: MainAxisSize.max,
          ),
        ],
      ),
    );
  }
}
