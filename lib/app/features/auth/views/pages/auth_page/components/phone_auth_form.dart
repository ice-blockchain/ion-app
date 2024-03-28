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
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/components/country_code_input.dart';
import 'package:ice/app/features/auth/views/pages/select_country/select_country_return_data.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/utils/validators.dart';
import 'package:ice/generated/assets.gen.dart';

class PhoneAuthForm extends HookConsumerWidget {
  const PhoneAuthForm({super.key});

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authProvider);
    final ValueNotifier<Country> country = useState(countries[1]);
    final TextEditingController inputController = useTextEditingController();

    return Column(
      children: <Widget>[
        Form(
          key: _formKey,
          child: TextInput(
            prefix: Text(country.value.iddCode),
            prefixIcon: CountryCodeInput(
              country: country.value,
              onTap: () async {
                final SelectCountryReturnData? data = await IceRoutes
                    .selectCountries
                    .push<SelectCountryReturnData>(context);
                if (data != null) {
                  country.value = data.country;
                }
              },
            ),
            labelText: context.i18n.auth_signIn_input_phone_number,
            controller: inputController,
            validator: (String? value) {
              if (!Validators.notEmpty(value)) return '';
              return null;
            },
            textInputAction: TextInputAction.done,
            numbersOnly: true,
          ),
        ),
        SizedBox(
          height: 16.0.s,
        ),
        Button(
          disabled: authState is AuthenticationLoading,
          trailingIcon: authState is AuthenticationLoading
              ? const ButtonLoadingIndicator()
              : Assets.images.icons.iconButtonNext.icon(
                  color: context.theme.appColors.onPrimaryAccent,
                ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              IceRoutes.enterCode.push(context);
            }
          },
          label: Text(context.i18n.button_continue),
          mainAxisSize: MainAxisSize.max,
        ),
      ],
    );
  }
}
