import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/app/router/my_app_routes.dart';
import 'package:ice/app/services/keyboard/keyboard.dart';
import 'package:ice/app/utils/validators.dart';
import 'package:ice/generated/assets.gen.dart';

class EmailAuthForm extends HookConsumerWidget {
  const EmailAuthForm({super.key});

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();
    final inputController = useTextEditingController();
    final loading = useState(false);

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
              if (Validators.isEmpty(value)) return '';
              if (Validators.isInvalidEmail(value)) {
                return context.i18n.email_input_invalid_email_format;
              }
              return null;
            },
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
                  // callback: () => IceRoutes.checkEmail.push(context),
                  callback: () => const CheckEmailRoute().push<void>(context),
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
