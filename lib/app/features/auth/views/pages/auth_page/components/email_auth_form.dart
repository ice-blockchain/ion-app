import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/utils/validators.dart';
import 'package:ice/generated/assets.gen.dart';

class EmailAuthForm extends HookConsumerWidget {
  EmailAuthForm({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authProvider);
    final TextEditingController inputController = useTextEditingController();

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextInput(
            prefixIcon: TextInputIcons(
              hasRightDivider: true,
              icons: <Widget>[
                Assets.images.icons.iconFieldEmail.icon(
                  color: context.theme.appColors.secondaryText,
                ),
              ],
            ),
            labelText: context.i18n.auth_signIn_input_email,
            controller: inputController,
            validator: (String? value) {
              if (!Validators.notEmpty(value)) return '';
              if (!Validators.validEmail(value)) {
                return context.i18n.email_input_invalid_email_format;
              }
              return null;
            },
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
                ref
                    .read(authProvider.notifier)
                    .signIn(email: inputController.value.text, password: '123');
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
