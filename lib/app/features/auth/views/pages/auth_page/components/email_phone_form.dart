import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/string.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/components/country_code_input.dart';
import 'package:ice/app/features/auth/views/pages/select_country/countries.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

class EmailPhoneForm extends HookConsumerWidget {
  const EmailPhoneForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authProvider);
    final TextEditingController inputController = useTextEditingController();

    return Column(
      children: <Widget>[
        TextInput(
          prefixIcon: TextInputIcons(
            icons: <Widget>[
              CountryCodeInput(
                country: countries[1],
                onTap: () => IceRoutes.selectCountries.push(context),
              ),
            ],
          ),
          labelText: context.i18n.auth_signIn_input_phone_number,
          controller: inputController,
          validator: (String? value) {
            if (value.isEmpty) {
              return 'no values'; //TODO::tr
            }
            return null;
          },
          numbersOnly: true,
        ),
        SizedBox(
          height: 16.0.s,
        ),
        Button(
          trailingIcon: authState is AuthenticationLoading
              ? const ButtonLoadingIndicator()
              : Assets.images.icons.iconButtonNext.icon(
                  color: context.theme.appColors.onPrimaryAccent,
                ),
          onPressed: () => <void>{
            ref
                .read(authProvider.notifier)
                .signIn(email: 'foo@bar.baz', password: '123'),
          },
          label: Text(context.i18n.button_continue),
          mainAxisSize: MainAxisSize.max,
        ),
      ],
    );
  }
}
